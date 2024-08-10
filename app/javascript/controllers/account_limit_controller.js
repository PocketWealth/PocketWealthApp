import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

    showRRSPUpdateLimitForm() {
        // Show the form
        const rrsp_limit_form_div = document.getElementById("rrsp_limit_update_div")
        rrsp_limit_form_div.classList.remove("hidden")

        //hide the main content
        const rrsp_limit_display = document.getElementById("rrsp_limit_display")
        rrsp_limit_display.classList.add("hidden")
    }

    showRRSPUpdateContributionsForm() {
        console.log("Hello world!")
        // Show the form
        const rrsp_contributions_form_div = document.getElementById("rrsp_contributions_update_div")
        rrsp_contributions_form_div.classList.remove("hidden")

        //hide the main content
        const rrsp_contributions_display = document.getElementById("rrsp_contributions_display")
        rrsp_contributions_display.classList.add("hidden")
    }

    showTFSAUpdateLimitForm() {
        // Show the form
        const tfsa_limit_form_div = document.getElementById("tfsa_limit_update_div")
        tfsa_limit_form_div.classList.remove("hidden")

        //hide the main content
        const tfsa_limit_display = document.getElementById("tfsa_limit_display")
        tfsa_limit_display.classList.add("hidden")
    }

    showTFSAUpdateContributionsForm() {
        // Show the form
        const tfsa_contributions_form_div = document.getElementById("tfsa_contributions_update_div")
        tfsa_contributions_form_div.classList.remove("hidden")

        //hide the main content
        const tfsa_contributions_display = document.getElementById("tfsa_contributions_display")
        tfsa_contributions_display.classList.add("hidden")
    }

    showFHSAUpdateLimitForm() {
        // Show the form
        const fhsa_limit_form_div = document.getElementById("fhsa_limit_update_div")
        fhsa_limit_form_div.classList.remove("hidden")

        //hide the main content
        const fhsa_limit_display = document.getElementById("fhsa_limit_display")
        fhsa_limit_display.classList.add("hidden")
    }

    showFHSAUpdateContributionsForm() {
        // Show the form
        const fhsa_contributions_form_div = document.getElementById("fhsa_contributions_update_div")
        fhsa_contributions_form_div.classList.remove("hidden")

        //hide the main content
        const fhsa_contributions_display = document.getElementById("fhsa_contributions_display")
        fhsa_contributions_display.classList.add("hidden")
    }

}
