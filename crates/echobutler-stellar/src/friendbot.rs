use echobutler_core::{EchoButlerClient, EchoButlerError, Result};
use reqwest::Client;

/// Fund a Stellar testnet account using Friendbot (gives 10,000 XLM).
/// Returns an error if called on mainnet — testnet only.
///
/// ```rust,no_run
/// use echobutler_core::{EchoButlerClient, EchoButlerConfig};
/// use echobutler_stellar::fund_testnet_account;
///
/// #[tokio::main]
/// async fn main() {
///     let client = EchoButlerClient::new(EchoButlerConfig::testnet("api_key")).unwrap();
///     fund_testnet_account(&client, "GPUBLIC_KEY").await.unwrap();
///     println!("Funded! Account now has 10,000 XLM on testnet.");
/// }
/// ```
pub async fn fund_testnet_account(client: &EchoButlerClient, public_key: &str) -> Result<()> {
    let friendbot_url = client.config().resolved_friendbot_url().ok_or_else(|| {
        EchoButlerError::Config("fund_testnet_account is only available on testnet".into())
    })?;

    let url = format!("{}?addr={}", friendbot_url, public_key);
    let res = Client::new()
        .get(&url)
        .send()
        .await
        .map_err(EchoButlerError::Network)?;

    if !res.status().is_success() {
        let body = res.text().await.unwrap_or_default();
        return Err(EchoButlerError::Stellar(format!(
            "Friendbot funding failed: {}",
            body
        )));
    }

    Ok(())
}
