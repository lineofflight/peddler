//! What every URL a caller supplies must pass. Each caller maps a failure to its own
//! error and adds its own rules.
use reqwest::Url;

/// Everything but unreserved characters is escaped in a path segment.
pub(crate) const SEGMENT: &percent_encoding::AsciiSet = &percent_encoding::NON_ALPHANUMERIC
    .remove(b'-')
    .remove(b'_')
    .remove(b'.')
    .remove(b'~');

/// An absolute URL with a host and no userinfo or fragment, and its scheme as written.
/// The text is checked before it is parsed, since parsing normalizes backslashes and
/// userinfo: it has no whitespace, control character, backslash, `#` or `forbidden`
/// character, and its authority is not empty.
pub(crate) fn parse<'a>(text: &'a str, forbidden: &[char]) -> Option<(&'a str, Url)> {
    if text.chars().any(|c| {
        c.is_whitespace() || c.is_control() || matches!(c, '\\' | '#') || forbidden.contains(&c)
    }) {
        return None;
    }
    let (scheme, rest) = text.split_once("://")?;
    let authority = rest.split(['/', '?']).next()?;
    if authority.is_empty() || authority.contains('@') {
        return None;
    }
    let url = Url::parse(text).ok()?;
    let plain = url.host_str().is_some() && url.username().is_empty() && url.password().is_none();
    plain.then_some((scheme, url))
}

pub(crate) fn is_loopback(url: &Url) -> bool {
    url.host_str().is_some_and(|host| {
        host == "localhost"
            || host
                .trim_matches(['[', ']'])
                .parse::<std::net::IpAddr>()
                .is_ok_and(|ip| ip.is_loopback())
    })
}

/// Whether every `%` starts a two-digit escape.
pub(crate) fn well_escaped(text: &str) -> bool {
    let bytes = text.as_bytes();
    bytes.iter().enumerate().all(|(index, byte)| {
        *byte != b'%'
            || bytes
                .get(index + 1..index + 3)
                .is_some_and(|hex| hex.iter().all(u8::is_ascii_hexdigit))
    })
}
