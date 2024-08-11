import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static values = {
        stock: String
    }

    handleStockRowClick() {
        window.location.href = `/stocks/${this.stockValue}`;
    }
}
