import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

    deleteStock() {
        const confirmationModal = document.getElementById("delete-stock-confirm-modal");
        confirmationModal.showModal();
    }

    deleteStockConfirm(){
        const form = document.getElementById("delete-stock-form");
        form.submit();
    }
}
