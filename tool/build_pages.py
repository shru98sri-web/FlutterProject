import hashlib
import html
import re
import shutil
import subprocess
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
SITE = ROOT / "build" / "pages-site"
BASE_HREF = "/FlutterProject/"
MAIN_PATTERN = re.compile(
    r"^[ \t]*(?:void|Future(?:<[^>]+>)?)[ \t]+main[ \t]*\(", re.MULTILINE
)
COMMENTS_PATTERN = re.compile(r"/\*.*?\*/|//[^\n]*", re.DOTALL)
NON_SLUG_PATTERN = re.compile(r"[^a-z0-9]+")
UNBUILDABLE_ENTRYPOINTS = {
    ("candy_crush", "lib/main.dart"): (
        "The referenced pages/, bloc/, and model/ source files are missing."
    ),
}


def project_roots():
    roots = [ROOT]
    roots.extend(
        sorted(
            child
            for child in ROOT.iterdir()
            if child.is_dir() and (child / "pubspec.yaml").is_file()
        )
    )
    return roots


def has_main(path):
    source = path.read_text(encoding="utf-8", errors="replace")
    source = COMMENTS_PATTERN.sub("", source)
    return MAIN_PATTERN.search(source) is not None


def slugify(value):
    return NON_SLUG_PATTERN.sub("-", value.lower()).strip("-") or "app"


def entrypoints():
    entries = []
    used_slugs = set()

    for project in project_roots():
        library = project / "lib"
        if not library.is_dir():
            continue
        for source in sorted(library.rglob("*.dart")):
            if not has_main(source):
                continue
            relative = source.relative_to(project)
            reason = UNBUILDABLE_ENTRYPOINTS.get(
                (project.name, relative.as_posix())
            )
            if reason:
                slug = ""
            elif project == ROOT and relative == Path("lib/main.dart"):
                slug = ""
            else:
                project_slug = "root" if project == ROOT else slugify(project.name)
                source_slug = slugify(relative.with_suffix("").as_posix())
                slug = f"{project_slug}-{source_slug}"
                if slug in used_slugs:
                    suffix = hashlib.sha1(relative.as_posix().encode()).hexdigest()[:8]
                    slug = f"{slug}-{suffix}"
            if slug:
                if slug in used_slugs:
                    raise ValueError(f"Duplicate Pages slug: {slug}")
                used_slugs.add(slug)
            entries.append((project, source, relative, slug, reason))

    for project in sorted(
        child
        for child in ROOT.iterdir()
        if child.is_dir() and child != ROOT and not (child / "pubspec.yaml").is_file()
    ):
        library = project / "lib"
        if not library.is_dir():
            continue
        for source in sorted(library.rglob("*.dart")):
            if has_main(source):
                entries.append(
                    (
                        project,
                        source,
                        source.relative_to(project),
                        "",
                        "This folder has no pubspec.yaml and is not a Flutter package.",
                    )
                )

    return entries


def run(command, project):
    print(f"+ {' '.join(command)}", flush=True)
    subprocess.run(command, cwd=project, check=True)


def build_entry(project, source, slug):
    if not (project / "web" / "index.html").is_file():
        raise FileNotFoundError(f"Missing web/index.html in {project}")

    if project == ROOT and source == ROOT / "lib" / "main.dart":
        base_href = BASE_HREF
        output = SITE
    else:
        base_href = f"{BASE_HREF}apps/{slug}/"
        output = SITE / "apps" / slug

    target = source.relative_to(project).as_posix()
    run(
        [
            "flutter",
            "build",
            "web",
            "--release",
            "--target",
            target,
            "--base-href",
            base_href,
        ],
        project,
    )
    shutil.copytree(project / "build" / "web", output, dirs_exist_ok=True)


def render_catalog(entries):
    grouped = {}
    for project, _source, relative, slug, reason in entries:
        label = "Repository root" if project == ROOT else project.name.replace("_", " ").title()
        if reason:
            card = (
                '<div class="card unavailable" aria-disabled="true">'
                '<strong>{name}</strong><span>{path}</span>'
                '<span class="status">Unavailable: {reason}</span></div>'
            ).format(
                name=html.escape(relative.name),
                path=html.escape(relative.as_posix()),
                reason=html.escape(reason),
            )
        else:
            href = "../" if project == ROOT and not slug else f"{slug}/"
            card = '<a class="card" href="{href}">{name}<span>{path}</span></a>'.format(
                href=html.escape(href, quote=True),
                name=html.escape(relative.name),
                path=html.escape(relative.as_posix()),
            )
        grouped.setdefault(label, []).append(card)

    sections = []
    for label, cards in grouped.items():
        sections.append(
            '<section aria-label="{label}"><h2>{label}</h2><div class="apps">{cards}</div></section>'.format(
                label=html.escape(label),
                cards="".join(cards),
            )
        )

    template = (ROOT / "pages" / "index.html").read_text(encoding="utf-8")
    if "{{APP_GROUPS}}" not in template:
        raise ValueError("pages/index.html is missing the {{APP_GROUPS}} placeholder")
    (SITE / "apps" / "index.html").write_text(
        template.replace("{{APP_GROUPS}}", "\n".join(sections)),
        encoding="utf-8",
    )


def main():
    entries = entrypoints()
    if not entries:
        raise RuntimeError("No Dart lib entrypoints with a main() function were found")

    buildable = [entry for entry in entries if entry[4] is None]
    unavailable = [entry for entry in entries if entry[4] is not None]
    projects = sorted({entry[0] for entry in buildable}, key=lambda path: path.as_posix())
    print(
        f"Found {len(entries)} Dart entrypoints: {len(buildable)} buildable, "
        f"{len(unavailable)} unavailable.",
        flush=True,
    )
    for project, _source, relative, _slug, reason in unavailable:
        print(f"Unavailable {project.name}/{relative}: {reason}", flush=True)
    for project in projects:
        run(["flutter", "pub", "get"], project)

    if SITE.exists():
        shutil.rmtree(SITE)
    SITE.mkdir(parents=True)

    for project, source, _relative, slug, reason in entries:
        if reason:
            continue
        print(f"Building {project.name or 'repository root'}: {source.relative_to(project)}", flush=True)
        build_entry(project, source, slug)

    (SITE / "apps").mkdir(exist_ok=True)
    render_catalog(entries)
    print(
        f"Built {len(buildable)} apps; listed {len(unavailable)} unavailable entries in {SITE}",
        flush=True,
    )


if __name__ == "__main__":
    main()
