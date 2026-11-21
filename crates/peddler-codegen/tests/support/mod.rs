use std::{fs, path::Path};

/// Writes a schema for each of those at the pin, and the patches.
pub fn write_supplemental(root: &Path) {
    let checkout = root.join("selling-partner-api-models");
    let pinned = Path::new(env!("CARGO_MANIFEST_DIR")).join("../../selling-partner-api-models");
    for source in peddler_codegen::supplemental::sources(&pinned).unwrap() {
        let path = checkout.join(&source.path);
        fs::create_dir_all(path.parent().unwrap()).unwrap();
        // A patch only applies to the schema it was written for.
        if peddler_codegen::supplemental::PATCHES
            .iter()
            .any(|(name, _)| *name == source.module)
        {
            fs::copy(pinned.join(&source.path), &path).unwrap();
        } else if source.family == "data_kiosk" {
            fs::write(
                &path,
                "type Query { record: Record } type Record { asin: String! }",
            )
            .unwrap();
        } else {
            fs::write(
                &path,
                r#"{"type":"object","properties":{"id":{"type":"string"}}}"#,
            )
            .unwrap();
        }
    }
    for (name, bytes) in peddler_codegen::supplemental::PATCHES {
        let path = root.join(format!("lib/generator/patches/{name}.json"));
        fs::create_dir_all(path.parent().unwrap()).unwrap();
        fs::write(path, bytes).unwrap();
    }
}
