use peddler_codegen::generate_models as generate;
use serde_json::json;
use std::{
    fs,
    path::{Path, PathBuf},
    process::{Command, Output},
};
use tempfile::TempDir;

const SOURCES: [&str; 2] = [
    "catalog-items-api-model/catalogItems_2022-04-01.json",
    "listings-items-api-model/listingsItems_2021-08-01.json",
];

fn write_specs(models: &Path) {
    for source in SOURCES {
        let path = models.join(source);
        fs::create_dir_all(path.parent().unwrap()).unwrap();
        fs::write(
            path,
            json!({"swagger":"2.0", "definitions": {
                "Item": {"type":"object", "required":["sku"], "properties":{
                    "sku":{"type":"string"}, "values":{"type":"array", "items":{"type":"string"}}
                }}
            }})
            .to_string(),
        )
        .unwrap();
    }
}

fn git(root: &Path, args: &[&str]) -> String {
    let output = Command::new("git")
        .arg("-C")
        .arg(root)
        .args(args)
        .env("GIT_AUTHOR_NAME", "Codegen test")
        .env("GIT_AUTHOR_EMAIL", "test@example.invalid")
        .env("GIT_COMMITTER_NAME", "Codegen test")
        .env("GIT_COMMITTER_EMAIL", "test@example.invalid")
        .output()
        .unwrap();
    assert!(
        output.status.success(),
        "{}",
        String::from_utf8_lossy(&output.stderr)
    );
    String::from_utf8(output.stdout).unwrap().trim().to_owned()
}

fn repository() -> TempDir {
    let root = tempfile::tempdir().unwrap();
    let checkout = root.path().join("selling-partner-api-models");
    write_specs(&checkout.join("models"));
    git(&checkout, &["init", "--quiet"]);
    git(&checkout, &["add", "."]);
    git(
        &checkout,
        &[
            "-c",
            "commit.gpgsign=false",
            "commit",
            "--quiet",
            "-m",
            "specs",
        ],
    );
    fs::write(
        root.path().join("selling-partner-api-models.sha"),
        git(&checkout, &["rev-parse", "HEAD"]) + "\n",
    )
    .unwrap();
    root
}

fn cli(root: &Path, extra: &[&str]) -> Output {
    Command::new(env!("CARGO_BIN_EXE_peddler-codegen"))
        .arg("--models-only")
        .arg("--output-root")
        .arg(root.join("model-export"))
        .arg("--root")
        .arg(root)
        .args(extra)
        .output()
        .unwrap()
}

#[test]
fn generation_renders_both_definition_sets_deterministically() {
    let specs = tempfile::tempdir().unwrap();
    write_specs(specs.path());
    let first = generate(specs.path(), "test-revision").unwrap();
    let second = generate(specs.path(), "test-revision").unwrap();
    assert_eq!(first, second);
    let expected: Vec<PathBuf> = [
        "mod.rs",
        "catalog_items_2022_04_01/mod.rs",
        "catalog_items_2022_04_01/models.rs",
        "listings_items_2021_08_01/mod.rs",
        "listings_items_2021_08_01/models.rs",
    ]
    .map(|path| Path::new("crates/peddler/src/apis").join(path))
    .into();
    assert_eq!(
        first
            .keys()
            .cloned()
            .collect::<std::collections::BTreeSet<_>>(),
        expected.into_iter().collect()
    );
    for (path, content) in &first {
        assert!(content.contains("test-revision"), "{}", path.display());
        syn::parse_file(content).unwrap();
    }
    let other_revision = generate(specs.path(), "another-revision").unwrap();
    assert_ne!(first, other_revision);
}

#[test]
fn cli_generates_twice_and_checks_without_writing() {
    let root = repository();
    let dest = tempfile::tempdir().unwrap();
    let dest_str = dest.path().to_str().unwrap();
    let options = ["--output-root", dest_str];
    let result = cli(root.path(), &options);
    assert!(
        result.status.success(),
        "{}",
        String::from_utf8_lossy(&result.stderr)
    );
    let generated = dest
        .path()
        .join("crates/peddler/src/apis/catalog_items_2022_04_01/models.rs");
    let first = fs::read(&generated).unwrap();
    assert!(cli(root.path(), &options).status.success());
    assert_eq!(fs::read(&generated).unwrap(), first);
    let modified = fs::metadata(&generated).unwrap().modified().unwrap();
    assert!(
        cli(root.path(), &["--output-root", dest_str, "--check"])
            .status
            .success()
    );
    assert_eq!(
        fs::metadata(&generated).unwrap().modified().unwrap(),
        modified
    );
}

#[test]
fn check_detects_missing_and_drifted_outputs_without_mutation() {
    let root = repository();
    let missing = root
        .path()
        .join("model-export/crates/peddler/src/apis/mod.rs");
    let result = cli(root.path(), &["--check"]);
    assert!(!result.status.success());
    assert!(!missing.exists());
    assert!(String::from_utf8_lossy(&result.stderr).contains("mod.rs"));
    assert!(cli(root.path(), &[]).status.success());
    fs::write(&missing, "// drift\n").unwrap();
    let modified = fs::metadata(&missing).unwrap().modified().unwrap();
    let result = cli(root.path(), &["--check"]);
    assert!(!result.status.success());
    assert!(String::from_utf8_lossy(&result.stderr).contains("mod.rs"));
    assert_eq!(fs::read_to_string(&missing).unwrap(), "// drift\n");
    assert_eq!(
        fs::metadata(&missing).unwrap().modified().unwrap(),
        modified
    );
}

#[test]
fn mismatched_revision_is_rejected_before_writing() {
    let root = repository();
    fs::write(
        root.path().join("selling-partner-api-models.sha"),
        "0000000000000000000000000000000000000000\n",
    )
    .unwrap();
    let result = cli(root.path(), &[]);
    assert!(!result.status.success());
    assert!(String::from_utf8_lossy(&result.stderr).contains("revision"));
    assert!(!root.path().join("model-export/crates").exists());
}

#[test]
fn modified_and_untracked_selected_sources_are_rejected() {
    let root = repository();
    let checkout = root.path().join("selling-partner-api-models");
    let source = checkout.join("models").join(SOURCES[0]);
    fs::write(&source, "{}\n").unwrap();
    let result = cli(root.path(), &[]);
    assert!(!result.status.success());
    assert!(String::from_utf8_lossy(&result.stderr).contains("modified"));
    assert!(!root.path().join("model-export/crates").exists());
    git(&checkout, &["checkout", "--", "models"]);
    git(
        &checkout,
        &["rm", "--cached", &format!("models/{}", SOURCES[0])],
    );
    let result = cli(root.path(), &[]);
    assert!(!result.status.success());
    assert!(!root.path().join("model-export/crates").exists());
}

#[test]
fn unrelated_checkout_changes_do_not_block_selected_generation() {
    let root = repository();
    fs::write(
        root.path()
            .join("selling-partner-api-models/unrelated.json"),
        "{}",
    )
    .unwrap();
    let result = cli(root.path(), &[]);
    assert!(
        result.status.success(),
        "{}",
        String::from_utf8_lossy(&result.stderr)
    );
}

#[test]
fn invalid_second_schema_does_not_leave_partial_outputs() {
    let root = repository();
    let checkout = root.path().join("selling-partner-api-models");
    fs::write(checkout.join("models").join(SOURCES[1]), "{}").unwrap();
    git(&checkout, &["add", "."]);
    git(
        &checkout,
        &[
            "-c",
            "commit.gpgsign=false",
            "commit",
            "--quiet",
            "-m",
            "invalid",
        ],
    );
    fs::write(
        root.path().join("selling-partner-api-models.sha"),
        git(&checkout, &["rev-parse", "HEAD"]) + "\n",
    )
    .unwrap();
    let result = cli(root.path(), &[]);
    assert!(!result.status.success());
    assert!(String::from_utf8_lossy(&result.stderr).contains("definitions"));
    assert!(!root.path().join("model-export/crates").exists());
}

#[test]
fn model_only_cli_requires_an_explicit_separate_output_root() {
    let root = repository();
    let mut destinations = vec![
        None,
        Some(root.path().to_path_buf()),
        Some(root.path().join(".")),
        Some(root.path().join("missing/..")),
    ];
    #[cfg(unix)]
    {
        let alias = root.path().join("same-root");
        std::os::unix::fs::symlink(root.path(), &alias).unwrap();
        destinations.push(Some(alias));
    }
    for output_root in destinations {
        let mut command = Command::new(env!("CARGO_BIN_EXE_peddler-codegen"));
        command.arg("--root").arg(root.path()).arg("--models-only");
        if let Some(path) = output_root {
            command.arg("--output-root").arg(path);
        }
        let output = command.output().unwrap();
        assert!(!output.status.success());
        assert!(
            String::from_utf8_lossy(&output.stderr)
                .contains("--models-only requires --output-root distinct from --root")
        );
        assert!(!root.path().join("crates").exists());
    }
}

#[cfg(unix)]
#[test]
fn unresolved_parent_traversal_through_symlink_cannot_overwrite_integrated_modules() {
    let root = repository();
    let base = tempfile::tempdir().unwrap();
    fs::create_dir(root.path().join("subdir")).unwrap();
    std::os::unix::fs::symlink(root.path().join("subdir"), base.path().join("alias")).unwrap();
    let output_root = base.path().join("alias/missing/../..");
    assert!(output_root.canonicalize().is_err());
    let integrated = root.path().join("crates/peddler/src/apis/mod.rs");
    fs::create_dir_all(integrated.parent().unwrap()).unwrap();
    fs::write(&integrated, "// integrated declaration sentinel\n").unwrap();
    let modified = fs::metadata(&integrated).unwrap().modified().unwrap();
    for check in [false, true] {
        let mut args = vec!["--output-root", output_root.to_str().unwrap()];
        if check {
            args.push("--check");
        }
        let output = cli(root.path(), &args);
        assert!(
            !output.status.success(),
            "unsafe output accepted; sentinel retained: {}",
            fs::read_to_string(&integrated).unwrap() == "// integrated declaration sentinel\n"
        );
        assert!(String::from_utf8_lossy(&output.stderr).contains("unresolved parent traversal"));
        assert_eq!(
            fs::read_to_string(&integrated).unwrap(),
            "// integrated declaration sentinel\n"
        );
        assert_eq!(
            fs::metadata(&integrated).unwrap().modified().unwrap(),
            modified
        );
        assert!(!root.path().join("subdir/missing").exists());
    }
}

#[cfg(unix)]
#[test]
fn existing_symlink_to_separate_export_root_remains_supported() {
    let root = repository();
    let destination = tempfile::tempdir().unwrap();
    let base = tempfile::tempdir().unwrap();
    let alias = base.path().join("export");
    std::os::unix::fs::symlink(destination.path(), &alias).unwrap();
    let output = cli(root.path(), &["--output-root", alias.to_str().unwrap()]);
    assert!(
        output.status.success(),
        "{}",
        String::from_utf8_lossy(&output.stderr)
    );
    assert!(
        destination
            .path()
            .join("crates/peddler/src/apis/mod.rs")
            .exists()
    );
    assert!(!root.path().join("crates").exists());
}
