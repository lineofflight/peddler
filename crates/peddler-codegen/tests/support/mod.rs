use std::{fs, path::Path};

pub fn write_supplemental(root: &Path) {
    let checkout = root.join("selling-partner-api-models");
    for source in peddler_codegen::supplemental::sources() {
        let path = checkout.join(&source.path);
        fs::create_dir_all(path.parent().unwrap()).unwrap();
        let fixture = Path::new(env!("CARGO_MANIFEST_DIR"))
            .join("../peddler/tests/fixtures/supplemental")
            .join(path.file_name().unwrap());
        if fixture.exists()
            && peddler_codegen::supplemental::PATCHES
                .iter()
                .any(|(name, _)| *name == source.module)
        {
            fs::copy(fixture, &path).unwrap();
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
