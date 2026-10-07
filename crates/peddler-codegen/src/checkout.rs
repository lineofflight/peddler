//! Checks that the spec checkout is at the pinned revision and that every source
//! generation reads is tracked there and unmodified.
use crate::{GenerationError, manifest::ALL_APIS, supplemental};
use std::{collections::BTreeSet, path::Path, process::Command};

pub(crate) fn git(root: &Path, args: &[&str]) -> Result<String, GenerationError> {
    let output = Command::new("git")
        .arg("-C")
        .arg(root)
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

/// Fails unless the checkout is at `revision` and holds exactly the audited sources.
pub fn verify(checkout: &Path, revision: &str) -> Result<(), GenerationError> {
    let actual = git(checkout, &["rev-parse", "HEAD"])?;
    if actual.trim() != revision {
        return Err(GenerationError(format!(
            "checkout revision {} does not match pin {revision}",
            actual.trim()
        )));
    }
    let specs = ALL_APIS
        .iter()
        .map(|api| format!("models/{}", api.source))
        .collect();
    verify_pinned(
        checkout,
        revision,
        &["models"],
        |path| path.ends_with(".json"),
        &specs,
        "API",
    )?;
    supplemental::verify_sources(checkout, revision)
}

/// Fails unless the files the pinned revision tracks under `roots`, of those `filter`
/// keeps, are exactly `expected`, and none is modified or untracked in the checkout.
/// `label` names them in the error.
pub(crate) fn verify_pinned(
    checkout: &Path,
    revision: &str,
    roots: &[&str],
    filter: impl Fn(&str) -> bool,
    expected: &BTreeSet<String>,
    label: &str,
) -> Result<(), GenerationError> {
    let mut args = vec!["ls-tree", "-r", "--name-only", revision, "--"];
    args.extend(roots);
    let tracked: BTreeSet<String> = git(checkout, &args)?
        .lines()
        .filter(|path| filter(path))
        .map(str::to_owned)
        .collect();
    if tracked != *expected {
        return Err(GenerationError(format!(
            "pinned {label} inventory mismatch; missing: {:?}; extra: {:?}",
            expected.difference(&tracked).collect::<Vec<_>>(),
            tracked.difference(expected).collect::<Vec<_>>()
        )));
    }
    let mut args = vec!["status", "--porcelain", "--untracked-files=all", "--"];
    args.extend(expected.iter().map(String::as_str));
    if !git(checkout, &args)?.is_empty() {
        return Err(GenerationError(format!("{label} sources are modified")));
    }
    let mut args = vec!["ls-files", "--error-unmatch", "--"];
    args.extend(expected.iter().map(String::as_str));
    git(checkout, &args)
        .map_err(|_| GenerationError(format!("{label} sources are untracked or missing")))?;
    Ok(())
}
