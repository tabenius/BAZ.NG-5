#[cfg_attr(mobile, tauri::mobile_entry_point)]
pub fn run() {
    tauri::Builder::default()
        .setup(|app| {
            tauri::WebviewWindowBuilder::new(app, "main", tauri::WebviewUrl::App("index.html".into()))
                .title("BAZ NG-5")
                .inner_size(480.0, 900.0)
                .build()?;
            Ok(())
        })
        // No application commands, plugins or IPC capabilities: the page is the whole app.
        .run(tauri::generate_context!())
        .expect("BAZ NG-5 could not start");
}
