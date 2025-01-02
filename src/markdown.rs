use crate::rss::fetch_itunes_most_played;
use crate::rss::Result;
use chrono;

fn markdown_table_row(values: &[&str]) -> String {
    format!("| {} |\n", values.join(" | "))
}

fn markdown_link(name: &str, url: &str) -> String {
    format!("[{}]({})", name, url)
}

// Generates the markdown content for the ranking table
pub async fn generate_markdown_content() -> Result<String> {
    let header = vec!["Rank", "ArtWork", "Song"];
    let mut content: String = markdown_table_row(&header);
    content += &markdown_table_row(&["---", "---", "---"]);

    let tracks = fetch_itunes_most_played(100).await?;
    for (index, track) in tracks.iter().enumerate() {
        let index_str = (index + 1).to_string();
        let artwork = String::from("!") + &markdown_link(&track.name, &track.artwork_url100);
        let song_info = markdown_link(&track.info(), &track.url);
        content += &markdown_table_row(&[&index_str, &artwork, &song_info]);
    }

    let reference_link =
        markdown_link("RSS Feed Generator", "https://rss.applemarketingtools.com/");
    content += &format!(
        "\n- {}\n- Reference: {}",
        chrono::Local::now(),
        reference_link
    );
    Ok(content)
}
