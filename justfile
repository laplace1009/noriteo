# 기본 레시피 - just만 입력하면 setup 후 dev 실행
default: setup dev

# 🛠️ 개발 환경 설정 (wasm-pack 설치 체크)
setup:
    @echo "🛠️ Setting up development environment..."
    @if ! command -v wasm-pack >/dev/null 2>&1; then \
        echo "📦 Installing wasm-pack..."; \
        cargo install wasm-pack; \
    else \
        echo "✅ wasm-pack already installed"; \
    fi

# 🚀 개발 서버 실행 (WASM 빌드 후 서버 시작)
dev: build-wasm
    @echo "🚀 Starting development server..."
    cargo run -p noriteo-server

# 🔨 WebAssembly 빌드
build-wasm:
    @echo "🔨 Building WebAssembly..."
    @if ! command -v wasm-pack >/dev/null 2>&1; then \
        echo "❌ wasm-pack not found. Run 'just setup' first"; \
        exit 1; \
    fi
    cd noriteo-client && wasm-pack build --target web --out-dir ../static

# 🧹 프로젝트 정리
clean:
    @echo "🧹 Cleaning up..."
    cargo clean
    rm -rf static/*.wasm static/*.js static/*.ts static/package.json

# ✅ 코드 검사
check:
    @echo "🔍 Checking code..."
    cargo check --workspace
    cargo clippy --workspace

# 🔧 포맷팅
fmt:
    @echo "🎨 Formatting code..."
    cargo fmt --all

# 📦 프로덕션 빌드
build: build-wasm
    @echo "📦 Building for production..."
    cargo build --release -p noriteo-server

# 🔄 WASM 재빌드 (개발 중 WASM만 다시 빌드할 때)
rebuild-wasm: clean-wasm build-wasm
    @echo "🔄 WASM rebuilt successfully!"

# 🧹 WASM 파일만 정리
clean-wasm:
    @echo "🧹 Cleaning WASM files..."
    rm -rf static/*.wasm static/*.js static/*.ts static/package.json

# 🔍 도구 상태 확인
status:
    @echo "📊 Development environment status:"
    @echo "Rust version: $(rustc --version)"
    @if command -v wasm-pack >/dev/null 2>&1; then \
        echo "wasm-pack: ✅ $(wasm-pack --version)"; \
    else \
        echo "wasm-pack: ❌ Not installed"; \
    fi
    @if command -v just >/dev/null 2>&1; then \
        echo "just: ✅ $(just --version)"; \
    else \
        echo "just: ❌ Not found"; \
    fi

# 🚀 빠른 시작 (처음 사용자용)
start: setup
    @echo "🚀 Quick start: Setting up and running development server..."
    @echo "📁 Creating necessary directories..."
    @mkdir -p templates static
    @echo "🔨 Building WASM..."
    @just build-wasm
    @echo "🚀 Starting server..."
    @just dev

# 📋 사용 가능한 명령어 목록
help:
    @echo "🦀 Rust + WASM + Axum Development Commands:"
    @echo ""
    @just --list
