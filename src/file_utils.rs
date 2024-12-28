use std::fs;
use std::fs::create_dir_all;
use std::io::Result as IoResult;
use std::path::Path;

// Writes the markdown content to a file
pub fn write_markdown_to_file(content: &str) -> IoResult<()> {
    let output_dir = Path::new("output");
    if !output_dir.exists() {
        create_dir_all(output_dir)?;
    }
    let file_path = output_dir.join("index.md");
    fs::write(file_path, content)?;
    println!("{}", &content[..std::cmp::min(100, content.len())]);
    Ok(())
}
