use reqwest::Client;

type Result<T> = std::result::Result<T, Box<dyn std::error::Error>>;

#[tokio::main]
async fn main() -> Result<()> {

    let client = Client::new();
    let url = "http://localhost/sample.json";

    let response = client
        .get(url)
        .send()
        .await?;

    let body = response.text().await?;
    println!("body: {}", body);

    Ok(())
}