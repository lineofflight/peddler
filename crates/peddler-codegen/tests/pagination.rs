//! Mapping validation against synthetic specs, plus checks of the committed
//! mapping file against the committed operation inventory.
use peddler_codegen::{
    clients,
    manifest::ALL_APIS,
    pagination::{Source, resolve},
};
use serde_json::{Value, json};
use std::collections::BTreeMap;

const MODULE: &str = "amazon_warehousing_and_distribution_2024_05_09";

fn spec() -> Value {
    json!({"swagger":"2.0","produces":["application/json"],"consumes":["application/json"],"info":{"title":"Synthetic","version":"1"},"paths":{
        "/items":{"get":{"operationId":"listItems","parameters":[
            {"name":"marketplaceId","in":"query","required":true,"type":"string"},
            {"name":"nextToken","in":"query","type":"string"},
            {"name":"count","in":"query","type":"integer","format":"int32"},
            {"name":"mode","in":"query","type":"string","enum":["FIRST","NEXT_TOKEN"]}],
            "responses":{"200":{"description":"ok","schema":{"$ref":"#/definitions/Page"}}}}},
        "/search":{"post":{"operationId":"searchItems","parameters":[
            {"name":"body","in":"body","required":true,"schema":{"$ref":"#/definitions/Search"}}],
            "responses":{"200":{"description":"ok","schema":{"$ref":"#/definitions/Page"}}}}},
        "/plain":{"get":{"operationId":"plain","parameters":[],
            "responses":{"200":{"description":"ok","schema":{"$ref":"#/definitions/Plain"}}}}},
        "/docs/{docId}/pages":{"get":{"operationId":"listPages","parameters":[
            {"name":"docId","in":"path","required":true,"type":"string"},
            {"name":"marketplaceId","in":"query","required":true,"type":"string"},
            {"name":"pageToken","in":"query","type":"string"}],
            "responses":{"200":{"description":"ok","schema":{"$ref":"#/definitions/Pages"}}}}},
        "/cursor":{"get":{"operationId":"cursorOnly","parameters":[],
            "responses":{"200":{"description":"ok","schema":{"$ref":"#/definitions/Cursor"}}}}}
    },"definitions":{
        "Page":{"type":"object","properties":{"payload":{"type":"object","properties":{"nextToken":{"type":"string"},"total":{"type":"integer"}}}}},
        "Search":{"type":"object","properties":{"filters":{"type":"object"},"nextToken":{"type":"string"},"limit":{"type":"integer"}}},
        "Pages":{"type":"object","properties":{"nextPageToken":{"type":"string"}}},
        "Plain":{"type":"object","properties":{"items":{"type":"array","items":{"type":"string"}}}},
        "Cursor":{"type":"object","properties":{"pagination":{"type":"object","properties":{"nextCursor":{"type":"string"}}}}}
    }})
}

fn run(source: Value, value: Value) -> Result<Vec<String>, String> {
    let source: Source = serde_json::from_value(source).map_err(|e| e.to_string())?;
    let api = &ALL_APIS[0];
    let rendered = clients::render(&value, api).map_err(|e| e.to_string())?;
    let clients = vec![(api, rendered)];
    let specs = BTreeMap::from([(api.module, value)]);
    resolve(&source, &clients, &specs)
        .map(|r| r.into_iter().map(|r| r.key).collect())
        .map_err(|e| e.to_string())
}
/// Excludes the synthetic operations the test does not map, so the audit passes.
fn decided(mappings: Value) -> Value {
    let mapped: Vec<_> = mappings
        .as_array()
        .unwrap()
        .iter()
        .map(|m| m["operation"].as_str().unwrap().to_owned())
        .collect();
    let exclusions: Vec<_> = ["cursor_only", "list_pages"]
        .iter()
        .map(|name| format!("{MODULE}.{name}"))
        .filter(|key| !mapped.contains(key))
        .map(|key| json!({"operation": key, "reason": "synthetic"}))
        .collect();
    json!({"mappings": mappings, "exclusions": exclusions})
}
fn pages(extra: Value) -> Value {
    let mut base = json!({"operation": format!("{MODULE}.list_pages"), "input": "/page_token", "output": "/nextPageToken"});
    base.as_object_mut()
        .unwrap()
        .extend(extra.as_object().unwrap().clone());
    base
}
fn mapping(extra: Value) -> Value {
    let mut base = json!({"operation": format!("{MODULE}.list_items"), "input": "/next_token", "output": "/payload/nextToken"});
    base.as_object_mut()
        .unwrap()
        .extend(extra.as_object().unwrap().clone());
    base
}

#[test]
fn valid_mappings_resolve_including_body_token_and_transition() {
    let ok = run(
        decided(json!([
            mapping(json!({"continuation": {"drop": ["count"], "set": {"mode": "NEXT_TOKEN"}}})),
            {"operation": format!("{MODULE}.search_items"), "input": "/body/nextToken", "output": "/payload/nextToken"}
        ])),
        spec(),
    );
    assert_eq!(ok.unwrap().len(), 2);
}

#[test]
fn every_mapped_reference_must_exist_and_be_a_string() {
    let cases = [
        (
            json!({"operation": format!("{MODULE}.missing")}),
            "unknown operation",
        ),
        (json!({"input": "/missing"}), "no argument"),
        (json!({"input": "/count"}), "string query argument"),
        (json!({"input": "next_token"}), "must start with /"),
        (json!({"output": "/payload/total"}), "not a string"),
        (json!({"output": "/payload/absent"}), "not a string"),
        (
            json!({"continuation": {"drop": ["nope"]}}),
            "no argument nope",
        ),
        (
            json!({"continuation": {"set": {"mode": "OTHER"}}}),
            "does not fit",
        ),
        (
            json!({"continuation": {"operation": format!("{MODULE}.nowhere")}}),
            "unknown operation",
        ),
    ];
    for (extra, expected) in cases {
        let error = run(decided(json!([mapping(extra)])), spec()).unwrap_err();
        assert!(error.contains(expected), "{expected}: {error}");
    }
    let body = json!({"operation": format!("{MODULE}.search_items"), "input": "/body/absent", "output": "/payload/nextToken"});
    assert!(
        run(decided(json!([body])), spec())
            .unwrap_err()
            .contains("body input")
    );
}

#[test]
fn duplicates_unknown_exclusions_and_undecided_fields_fail() {
    let error = run(
        decided(json!([mapping(json!({})), mapping(json!({}))])),
        spec(),
    )
    .unwrap_err();
    assert!(error.contains("decided twice"), "{error}");
    let unknown = json!({"mappings": [], "exclusions": [{"operation": format!("{MODULE}.nowhere"), "reason": "x"}]});
    assert!(
        run(unknown, spec())
            .unwrap_err()
            .contains("unknown operation")
    );
    // listItems carries nextToken, searchItems a body token, cursorOnly a cursor.
    let error = run(decided(json!([])), spec()).unwrap_err();
    assert!(error.contains("continuation-like field"), "{error}");
    let no_cursor = json!({"mappings": [mapping(json!({})), {"operation": format!("{MODULE}.search_items"), "input": "/body/nextToken", "output": "/payload/nextToken"}], "exclusions": []});
    assert!(run(no_cursor, spec()).unwrap_err().contains("cursor_only"));
}

#[test]
fn adapter_requires_a_get_that_keeps_exactly_its_path_arguments() {
    let search = json!({"operation": format!("{MODULE}.search_items"), "input": "/body/nextToken", "output": "/payload/nextToken"});
    let both = |extra: Value| decided(json!([mapping(json!({})), search.clone(), pages(extra)]));
    let ok = both(json!({"continuation": {"keep": ["doc_id"], "adapter": true}}));
    assert_eq!(run(ok, spec()).unwrap().len(), 3);
    for continuation in [
        json!({"keep": [], "adapter": true}),
        json!({"keep": ["doc_id", "marketplace_id"], "adapter": true}),
        json!({"keep": ["doc_id"], "drop": ["marketplace_id"], "adapter": true}),
    ] {
        let error = run(both(json!({"continuation": continuation})), spec()).unwrap_err();
        assert!(error.contains("adapter must be a GET"), "{error}");
    }
    let post = json!({"operation": format!("{MODULE}.search_items"), "input": "/body/nextToken", "output": "/payload/nextToken", "continuation": {"keep": [], "adapter": true}});
    let error = run(decided(json!([mapping(json!({})), post])), spec()).unwrap_err();
    assert!(error.contains("adapter must be a GET"), "{error}");
}

#[test]
fn unknown_fields_in_the_mapping_file_are_rejected() {
    assert!(
        run(
            json!({"mappings": [], "exclusions": [], "extra": 1}),
            spec()
        )
        .is_err()
    );
    assert!(
        run(
            json!({"mappings": [mapping(json!({"guess": true}))], "exclusions": []}),
            spec()
        )
        .is_err()
    );
}

#[test]
fn committed_mappings_match_the_committed_inventory() {
    let root = std::path::Path::new(env!("CARGO_MANIFEST_DIR"));
    let source: Value =
        serde_json::from_slice(&std::fs::read(root.join("pagination.json")).unwrap()).unwrap();
    let inventory: Value =
        serde_json::from_slice(&std::fs::read(root.join("operation-inventory.json")).unwrap())
            .unwrap();
    let mut operations = BTreeMap::new();
    for api in inventory["apis"].as_array().unwrap() {
        for op in api["operations"].as_array().unwrap() {
            operations.insert(op["key"].as_str().unwrap().to_owned(), op);
        }
    }
    let arguments = |key: &str| -> Vec<String> {
        operations[key]["parameters"]
            .as_array()
            .unwrap()
            .iter()
            .map(|p| p["name"].as_str().unwrap().to_owned())
            .collect()
    };
    let mappings = source["mappings"].as_array().unwrap();
    assert_eq!(mappings.len(), 79);
    let mut decided = std::collections::BTreeSet::new();
    for m in mappings {
        let key = m["operation"].as_str().unwrap();
        assert!(decided.insert(key), "{key} mapped twice");
        let own = arguments(key);
        let token = m["input"]
            .as_str()
            .unwrap()
            .trim_start_matches('/')
            .split('/')
            .next()
            .unwrap();
        assert!(own.iter().any(|a| a == token), "{key}: no argument {token}");
        let target = m["continuation"]["operation"]
            .as_str()
            .map_or_else(|| key.to_owned(), str::to_owned);
        let adapter = m["continuation"]["adapter"].as_bool().unwrap_or(false);
        if !adapter {
            let allowed = arguments(&target);
            let names = ["keep", "drop"].iter().flat_map(|k| {
                m["continuation"][k]
                    .as_array()
                    .into_iter()
                    .flatten()
                    .map(|v| v.as_str().unwrap().to_owned())
            });
            let set = m["continuation"]["set"]
                .as_object()
                .into_iter()
                .flatten()
                .map(|(k, _)| k.clone());
            for name in names.chain(set) {
                assert!(
                    allowed.contains(&name),
                    "{key}: {target} has no argument {name}"
                );
            }
        }
        assert_eq!(
            operations[key]["pagination"]["input"], m["input"],
            "{key}: inventory out of date"
        );
        assert_eq!(
            operations[key]["pagination"]["output"], m["output"],
            "{key}: inventory out of date"
        );
    }
    for e in source["exclusions"].as_array().unwrap() {
        let key = e["operation"].as_str().unwrap();
        assert!(operations.contains_key(key), "{key} does not exist");
        assert!(decided.insert(key), "{key} mapped and excluded");
        assert_eq!(operations[key]["pagination_exclusion"], e["reason"]);
        assert!(!e["reason"].as_str().unwrap().is_empty());
    }
    assert_eq!(operations.len(), 384);
    assert_eq!(
        operations
            .values()
            .filter(|o| !o["pagination"].is_null())
            .count(),
        mappings.len()
    );
}
