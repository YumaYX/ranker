mod rss;
mod markdown;
mod file_utils;

use markdown::generate_markdown_content;
use file_utils::write_markdown_to_file;

type Result<T> = std::result::Result<T, Box<dyn std::error::Error>>;

#[tokio::main]
async fn main() -> Result<()> {
    match generate_markdown_content().await {
        Ok(content) => {
            if let Err(e) = write_markdown_to_file(&content) {
                eprintln!("Failed to write markdown file: {}", e);
            }
        }
        Err(e) => eprintln!("Failed to generate markdown content: {}", e),
    }
    Ok(())
}
