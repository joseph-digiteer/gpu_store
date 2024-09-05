// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import "../stylesheets/application"
import "controllers/product_controller";
import "/controllers/admin_product"



document.addEventListener("DOMContentLoaded", function() {
    const seriesSelect = document.querySelector('select[name="product[existing_series]"]');
    const newSeriesFields = document.querySelector('.new-series-fields');
    const existingSeriesFields = document.querySelector('.existing-series-fields');
  
    function toggleSeriesFields(value) {
      if (value === "") {
        // Creating a new series
        newSeriesFields.classList.remove('hidden');
        existingSeriesFields.classList.add('hidden');
      } else {
        // Adding variants to an existing series
        newSeriesFields.classList.add('hidden');
        existingSeriesFields.classList.remove('hidden');
      }
    }
  
    // Initial check on page load
    toggleSeriesFields(seriesSelect.value);
  
    // Listen for changes
    seriesSelect.addEventListener('change', function() {
      toggleSeriesFields(this.value);
    });
  
    // Add functionality to add more variants
    document.querySelector('.add_variant').addEventListener('click', function(event) {
      event.preventDefault();
      const variantFields = document.querySelector('.nested-fields');
      const newVariantFields = variantFields.cloneNode(true);
      newVariantFields.querySelectorAll('input').forEach(input => input.value = '');
      variantFields.parentNode.insertBefore(newVariantFields, variantFields.nextSibling);
    });
  });
  
  