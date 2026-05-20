document.addEventListener("turbo:load", () => {
  const dropdownTrigger = document.querySelector(".header__nav-item--dropdown");
  const dropdown = document.querySelector(".header__dropdown");

    dropdownTrigger.addEventListener("mouseenter", () => {
      dropdown.classList.add("is-open");
    });

    dropdownTrigger.addEventListener("mouseleave", () => {
      dropdown.classList.remove("is-open");
    });
});
