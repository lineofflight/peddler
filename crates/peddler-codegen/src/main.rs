use peddler_codegen::{GenerationError, generate, generate_models, manifest::ALL_APIS};
use std::{
    fs,
    io::Write,
    path::{Path, PathBuf},
    process::Command,
};

fn main() {
    if let Err(error) = run() {
        eprintln!("peddler-codegen: {error}");
        std::process::exit(1);
    }
}

fn run() -> Result<(), GenerationError> {
    let mut root = PathBuf::from(env!("CARGO_MANIFEST_DIR")).join("../..");
    let mut output_root = None;
    let mut check = false;
    let mut models_only = false;
    let mut args = std::env::args_os().skip(1);
    while let Some(arg) = args.next() {
        if arg == "--root" || arg == "--output-root" {
            let path = args
                .next()
                .filter(|value| !value.to_string_lossy().starts_with("--"))
                .ok_or_else(|| {
                    GenerationError(format!("{} requires a path", arg.to_string_lossy()))
                })?;
            if arg == "--root" {
                root = path.into();
            } else {
                output_root = Some(PathBuf::from(path));
            }
        } else if arg == "--models-only" {
            models_only = true;
        } else if arg == "--check" {
            check = true;
        } else {
            return Err(GenerationError(format!(
                "unknown argument: {}",
                arg.to_string_lossy()
            )));
        }
    }
    if models_only
        && (output_root.is_none()
            || checked_output_path(output_root.as_ref().unwrap())? == root.canonicalize()?)
    {
        return Err(GenerationError(
            "--models-only requires --output-root distinct from --root".into(),
        ));
    }
    let revision = fs::read_to_string(root.join("selling-partner-api-models.sha"))?;
    let revision = revision.trim();
    if revision.len() != 40 || !revision.bytes().all(|byte| byte.is_ascii_hexdigit()) {
        return Err(GenerationError(
            "pin must contain a full Git revision".into(),
        ));
    }
    let checkout = root.join("selling-partner-api-models");
    let actual = git(&checkout, &["rev-parse", "HEAD"])?;
    if actual.trim() != revision {
        return Err(GenerationError(format!(
            "checkout revision {} does not match pin {revision}",
            actual.trim()
        )));
    }
    let sources: Vec<String> = ALL_APIS
        .iter()
        .map(|api| format!("models/{}", api.source))
        .collect();
    let inventory = git(
        &checkout,
        &["ls-tree", "-r", "--name-only", revision, "--", "models"],
    )?;
    let tracked: std::collections::BTreeSet<_> = inventory
        .lines()
        .filter(|path| path.ends_with(".json"))
        .map(str::to_owned)
        .collect();
    let expected: std::collections::BTreeSet<_> = sources.iter().cloned().collect();
    if tracked != expected {
        return Err(GenerationError(format!(
            "pinned API inventory mismatch; missing: {:?}; extra: {:?}",
            expected.difference(&tracked).collect::<Vec<_>>(),
            tracked.difference(&expected).collect::<Vec<_>>()
        )));
    }
    let mut status_args = vec!["status", "--porcelain", "--untracked-files=all", "--"];
    status_args.extend(sources.iter().map(String::as_str));
    if !git(&checkout, &status_args)?.is_empty() {
        return Err(GenerationError("API spec files are modified".into()));
    }
    let mut tracked_args = vec!["ls-files", "--error-unmatch", "--"];
    tracked_args.extend(sources.iter().map(String::as_str));
    git(&checkout, &tracked_args)
        .map_err(|_| GenerationError("API spec files are untracked or missing".into()))?;
    peddler_codegen::supplemental::verify_sources(&checkout, revision)?;
    let mut output = if models_only {
        generate_models(&checkout.join("models"), revision)?
    } else {
        generate(&checkout.join("models"), revision)?
    };
    if models_only {
        output.extend(peddler_codegen::generate_supplemental(&checkout, revision)?);
    }
    let dest = output_root.unwrap_or(root);
    if check {
        let mut drifted: Vec<_> = output
            .iter()
            .filter(|(path, content)| {
                fs::read(dest.join(path)).ok().as_deref() != Some(content.as_bytes())
            })
            .map(|(path, _)| path.display().to_string())
            .collect();
        if !models_only {
            let base = Path::new("crates/peddler/src/apis");
            for path in generated_rust_files(&dest, base)? {
                if !output.contains_key(&path) {
                    drifted.push(path.display().to_string());
                }
            }
        }
        if !drifted.is_empty() {
            return Err(GenerationError(format!(
                "generated outputs missing or drifted:\n{}",
                drifted.join("\n")
            )));
        }
    } else {
        // Stage every changed file before replacing any destination. Schema errors cannot
        // leave partially generated output; each replacement is an atomic rename.
        let mut staged = Vec::new();
        for (path, content) in output {
            let path = dest.join(path);
            if fs::read(&path).ok().as_deref() == Some(content.as_bytes()) {
                continue;
            }
            let parent = path.parent().expect("generated paths have parents");
            fs::create_dir_all(parent)?;
            let mut file = tempfile::NamedTempFile::new_in(parent)?;
            file.write_all(content.as_bytes())?;
            staged.push((path, file));
        }
        for (path, file) in staged {
            file.persist(path)
                .map_err(|error| GenerationError(error.to_string()))?;
        }
    }
    Ok(())
}

fn git(checkout: &Path, args: &[&str]) -> Result<String, GenerationError> {
    let output = Command::new("git")
        .arg("-C")
        .arg(checkout)
        .args(args)
        .output()?;
    if !output.status.success() {
        return Err(GenerationError(format!(
            "Git checkout verification failed: {}",
            String::from_utf8_lossy(&output.stderr).trim()
        )));
    }
    String::from_utf8(output.stdout).map_err(|error| GenerationError(error.to_string()))
}

// Resolve existing destinations through the filesystem. Reject parent traversal
// when a missing component prevents resolution: lexical removal of .. can give
// a different destination from traversal through a symlink during file writes.
fn checked_output_path(path: &Path) -> Result<PathBuf, GenerationError> {
    if let Ok(canonical) = path.canonicalize() {
        return Ok(canonical);
    }
    if path
        .components()
        .any(|component| component == std::path::Component::ParentDir)
    {
        return Err(GenerationError(
            "--models-only requires --output-root distinct from --root; unresolved parent traversal is not allowed".into(),
        ));
    }
    Ok(if path.is_absolute() {
        path.to_path_buf()
    } else {
        std::env::current_dir()?.join(path)
    })
}

fn generated_rust_files(root: &Path, relative: &Path) -> Result<Vec<PathBuf>, GenerationError> {
    let mut files = Vec::new();
    let Ok(entries) = fs::read_dir(root.join(relative)) else {
        return Ok(files);
    };
    for entry in entries {
        let entry = entry?;
        let path = relative.join(entry.file_name());
        if entry.file_type()?.is_dir() {
            files.extend(generated_rust_files(root, &path)?);
        } else if path.extension().is_some_and(|ext| ext == "rs")
            && fs::read_to_string(root.join(&path))?.starts_with("// Generated by peddler-codegen.")
        {
            files.push(path);
        }
    }
    Ok(files)
}
