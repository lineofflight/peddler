//! Mapping validation against synthetic specs.
use peddler_codegen::{
    clients,
    manifest::ModelSpec,
    pagination::{Resolution, Source, resolve},
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
            {"name":"marketplaceId","in":"query","type":"string"},
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

fn api() -> ModelSpec {
    ModelSpec {
        source: "amazon-warehousing-and-distribution-model/awd_2024-05-09.json".into(),
        module: MODULE.into(),
        family: "amazon_warehousing_and_distribution".into(),
        version: "2024_05_09".into(),
        latest: true,
    }
}
fn resolution(source: Value, value: Value) -> Result<Resolution, String> {
    let source: Source = serde_json::from_value(source).map_err(|e| e.to_string())?;
    let api = api();
    let operations = clients::render(&value, &api).map_err(|e| e.to_string())?;
    let clients = vec![(&api, operations)];
    let specs = BTreeMap::from([(api.module.as_str(), value)]);
    resolve(&source, &clients, &specs).map_err(|e| e.to_string())
}
fn run(source: Value, value: Value) -> Result<Vec<String>, String> {
    resolution(source, value).map(|r| r.resolved.into_iter().map(|r| r.key).collect())
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
fn duplicates_and_unknown_operations_fail() {
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
}

/// An operation that looks paged and that nothing decides still generates: it is unmapped,
/// with what looks like a page token, and gets no `*_pages` method.
#[test]
fn an_undecided_paged_operation_is_unmapped() {
    let unmapped = |source| {
        let resolution = resolution(source, spec()).unwrap();
        let unmapped: Vec<_> = resolution
            .unmapped
            .iter()
            .map(|op| {
                (
                    op.key.clone(),
                    op.id.clone(),
                    op.field.clone(),
                    op.source.clone(),
                )
            })
            .collect();
        (resolution.resolved.len(), unmapped)
    };
    let source = api().source;
    // listItems carries nextToken, searchItems a body token, cursorOnly a cursor.
    assert_eq!(
        unmapped(decided(json!([]))),
        (
            0,
            vec![
                (
                    format!("{MODULE}.list_items"),
                    "listItems".into(),
                    "nextToken".into(),
                    source.clone()
                ),
                (
                    format!("{MODULE}.search_items"),
                    "searchItems".into(),
                    "body/nextToken".into(),
                    source.clone()
                ),
            ]
        )
    );
    let no_cursor = json!({"mappings": [mapping(json!({})), {"operation": format!("{MODULE}.search_items"), "input": "/body/nextToken", "output": "/payload/nextToken"}], "exclusions": []});
    assert_eq!(
        unmapped(no_cursor),
        (
            2,
            vec![
                (
                    format!("{MODULE}.cursor_only"),
                    "cursorOnly".into(),
                    "response/pagination/nextCursor".into(),
                    source.clone()
                ),
                (
                    format!("{MODULE}.list_pages"),
                    "listPages".into(),
                    "pageToken".into(),
                    source
                ),
            ]
        )
    );
}

/// What `pagination.json` says of an API Amazon removed is stale, not wrong: it is set
/// aside, and the rest resolves.
#[test]
fn an_entry_of_a_removed_api_is_stale() {
    let gone = |name: &str| format!("orders_v0.{name}");
    let mut source = decided(
        json!([mapping(json!({})), {"operation": gone("get_orders"), "input": "/next_token", "output": "/payload/NextToken"}]),
    );
    source["exclusions"]
        .as_array_mut()
        .unwrap()
        .push(json!({"operation": gone("get_order_items"), "reason": "gone"}));
    let resolution = resolution(source, spec()).unwrap();
    assert_eq!(
        resolution.stale,
        [gone("get_order_items"), gone("get_orders")]
    );
    let keys: Vec<_> = resolution.resolved.iter().map(|r| r.key.as_str()).collect();
    assert_eq!(keys, [format!("{MODULE}.list_items")]);
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
