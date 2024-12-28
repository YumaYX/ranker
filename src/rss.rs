use serde::Deserialize;
use serde_json::Value;

pub type Result<T> = std::result::Result<T, Box<dyn std::error::Error>>;

#[derive(Debug, Deserialize)]
#[allow(dead_code)]
pub struct Feed {
    pub results: Vec<ResultItem>,
}

#[derive(Debug, Deserialize)]
pub struct ResultItem {
    pub name: String,
    #[serde(rename = "artistName")]
    pub artist_name: String,
    #[serde(rename = "artworkUrl100")]
    pub artwork_url100: String,
    pub url: String,
}

impl ResultItem {
    pub fn info(&self) -> String {
        format!("{} - {}", self.name, self.artist_name)
    }
}

#[derive(Debug, Deserialize)]
#[allow(dead_code)]
pub struct Root {
    pub feed: Feed,
}

// Fetches the most played songs from the iTunes RSS feed
pub async fn fetch_itunes_most_played(num: u32) -> Result<Vec<ResultItem>> {
    let url = format!(
        "https://rss.applemarketingtools.com/api/v2/jp/music/most-played/{}/songs.json",
        num
    );
    let response = reqwest::get(&url).await?.text().await?;
    let json: Value = serde_json::from_str(&response)?;
    let results: Vec<ResultItem> =
        serde_json::from_value(json["feed"]["results"].clone()).expect("Failed to convert results");
    Ok(results)
}
