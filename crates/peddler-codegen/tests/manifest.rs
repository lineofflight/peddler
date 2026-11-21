use peddler_codegen::manifest::ALL_APIS;
use std::collections::BTreeSet;

#[test]
fn sources_and_modules_are_unique_and_modules_are_named_after_family_and_version() {
    let sources: BTreeSet<_> = ALL_APIS.iter().map(|api| api.source).collect();
    let modules: BTreeSet<_> = ALL_APIS.iter().map(|api| api.module).collect();
    assert_eq!(sources.len(), ALL_APIS.len());
    assert_eq!(modules.len(), ALL_APIS.len());
    for api in ALL_APIS {
        assert_eq!(api.module, format!("{}_{}", api.family, api.version));
    }
}
