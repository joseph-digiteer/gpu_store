document.addEventListener("turbo:load", function() {
    const addVariantLink = document.querySelector('#add_variant');
    const variantContainer = document.querySelector('#variants');
  
    if (addVariantLink && variantContainer) {
      addVariantLink.addEventListener('click', function(e) {
        e.preventDefault(); // Prevent the default anchor behavior
  
        // Clone the last variant fieldset and append it
        const lastVariant = variantContainer.querySelector('.nested-fields:last-child');
        if (lastVariant) {
          const newVariant = lastVariant.cloneNode(true);
  
          // Clear input values in the cloned fieldset
          newVariant.querySelectorAll('input').forEach(input => {
            input.value = '';
          });
  
          // Append the new variant fieldset to the container
          variantContainer.appendChild(newVariant);
        }
      });
  
      variantContainer.addEventListener('click', function(e) {
        if (e.target.classList.contains('remove_variant')) {
          e.preventDefault(); // Prevent the default anchor behavior
  
          const variantField = e.target.closest('.nested-fields');
          if (variantField) {
            variantField.remove(); // Remove the variant field
          }
        }
      });
    }
  });
  