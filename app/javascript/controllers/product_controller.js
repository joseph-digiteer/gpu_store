import { Controller } from "stimulus";

export default class extends Controller {
  static targets = ["variant"];

  toggleVariants(event) {
    event.preventDefault();
    const productId = event.currentTarget.dataset.productId;
    this.variantTargets.forEach(variant => {
      if (variant.id.includes(`variant-${productId}`)) {
        variant.classList.toggle("hidden");
      }
    });
  }
}
