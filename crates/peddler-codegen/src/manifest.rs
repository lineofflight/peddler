/// Only these definition sets are generated in this milestone.
pub struct ApiSpec {
    pub module: &'static str,
    pub source: &'static str,
}

pub const APIS: &[ApiSpec] = &[
    ApiSpec {
        module: "catalog_items_2022_04_01",
        source: "catalog-items-api-model/catalogItems_2022-04-01.json",
    },
    ApiSpec {
        module: "listings_items_2021_08_01",
        source: "listings-items-api-model/listingsItems_2021-08-01.json",
    },
];
