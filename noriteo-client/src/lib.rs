use wasm_bindgen::prelude::*;
use wasm_bindgen::JsCast;
use web_sys::{console, window, HtmlElement};

#[wasm_bindgen]
extern "C" {
    fn alert(s: &str);
}

#[wasm_bindgen]
pub fn greet(name: &str) {
    alert(&format!("Hello, {name}! 🦀"));
}

#[wasm_bindgen(start)]
pub fn main() {
    console::log_1(&"🦀 WASM module loaded successfully!".into());
    
    let window = window().expect("no global `window` exists");
    let document = window.document().expect("should have a document on window");
    
    if let Some(button_element) = document.get_element_by_id("wasm-button") {
        // Element를 HtmlElement로 안전하게 캐스팅
        if let Ok(button) = button_element.dyn_into::<HtmlElement>() {
            let closure = Closure::wrap(Box::new(move || {
                console::log_1(&"Button clicked!".into());
                greet("WASM User");
            }) as Box<dyn FnMut()>);
            
            button.set_onclick(Some(closure.as_ref().unchecked_ref()));
            closure.forget();
        } else {
            console::log_1(&"❌ Failed to cast button to HtmlElement".into());
        }
    } else {
        console::log_1(&"❌ Button with id 'wasm-button' not found".into());
    }
}
