use peddler::{Client, apis};
#[test]
fn operation_dispatch_future_is_small_enough_for_native_thread_callbacks() {
    let client = Client::new("http://127.0.0.1:1", "dummy").unwrap();
    let future = apis::execute(&client, "sellers_v1.get_marketplace_participations", "{}");
    let bytes = std::mem::size_of_val(&future);
    assert!(
        bytes <= 32,
        "dispatcher future occupies {bytes} bytes on caller's stack"
    );
}
