use askama::Template;
use axum::{
    http::StatusCode,
    response::{Html, IntoResponse},
    routing::get,
    Router,
};
use tower_http::{
    cors::CorsLayer,
    services::ServeDir,
};

#[derive(Template)]
#[template(path = "index.html")]
struct IndexTemplate {
    title: String,
    message: String,
}

async fn index() -> impl IntoResponse {
    let template = IndexTemplate {
        title: "Noriteo".to_string(),
        message: "Hello from Axum + WASM! 🚀".to_string(),
    };
    
    match template.render() {
        Ok(html) => Html(html).into_response(),
        Err(err) => {
            eprintln!("Template error: {err}");
            (StatusCode::INTERNAL_SERVER_ERROR, "Template error").into_response()
        }
    }
}

#[tokio::main]
async fn main() {
    let app = Router::new()
        .route("/", get(index))
        .nest_service("/static", ServeDir::new("static"))
        .layer(CorsLayer::permissive());

    let listener = tokio::net::TcpListener::bind("0.0.0.0:3000")
        .await
        .expect("Failed to bind to address");
    println!("🚀 Noriteo server running on http://localhost:3000");
    
    axum::serve(listener, app)
        .await
        .expect("Server error");
}
