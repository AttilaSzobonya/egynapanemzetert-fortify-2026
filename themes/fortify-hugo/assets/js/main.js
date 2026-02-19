// main script
(function () {
  "use strict";

  // ########################## AOS ##########################
  document.addEventListener("DOMContentLoaded", function () {
    AOS.init({
      once: true,
    });
  });

  // Dropdown Menu Toggler For Mobile
  // ----------------------------------------
  const dropdownMenuToggler = document.querySelectorAll(
    ".nav-dropdown > .nav-link",
  );

  dropdownMenuToggler.forEach((toggler) => {
    toggler?.addEventListener("click", (e) => {
      e.target.closest(".nav-item").classList.toggle("active");
    });
  });

  // Testimonial Slider
  // ----------------------------------------
  new Swiper(".testimonial-slider", {
    spaceBetween: 24,
    loop: true,
    pagination: {
      el: ".testimonial-slider-pagination",
      type: "bullets",
      clickable: true,
    },
    breakpoints: {
      768: {
        slidesPerView: 2,
      },
      992: {
        slidesPerView: 3,
      },
    },
  });

  document.querySelectorAll('.primary-accordion-header').forEach(button => {
    button.addEventListener('click', function() {
      const accordion = this.parentElement;
      accordion.classList.toggle('active');
    });
  });


  //----- pricing plane ----- //
  function pricingInit() {
    // Select the toggle switch element
    const toggleSwitch = document.querySelector(".pricing-check");
    const numbers = document.querySelectorAll(".data-count");

    if (toggleSwitch) {
      toggleSwitch.addEventListener("change", function () {
        if (toggleSwitch.checked) {
          numbers.forEach(function (number) {
            const yearlyCount = number.getAttribute("data-count-yearly");
            if (yearlyCount) {
              number.innerHTML = yearlyCount;
              animateCounter(number, parseInt(yearlyCount, 10));
            }
          });
          toggleVisibility(".text-yearly", "block", "hidden");
          toggleVisibility(".text-monthly", "hidden", "block");
        } else {
          numbers.forEach(function (number) {
            const monthlyCount = number.getAttribute("data-count-monthly");
            if (monthlyCount) {
              number.innerHTML = monthlyCount;
              animateCounter(number, parseInt(monthlyCount, 10));
            }
          });
          toggleVisibility(".text-monthly", "block", "hidden");
          toggleVisibility(".text-yearly", "hidden", "block");
        }
      });
    }

    function animateCounter(element, endValue) {
      let startValue = 0;
      const duration = 250;
      let startTime = null;

      function step(currentTime) {
        if (!startTime) startTime = currentTime;
        const progress = currentTime - startTime;
        const value =
          Math.min(progress / duration, 1) * (endValue - startValue) + startValue;
        element.innerHTML = Math.ceil(value).toString();
        if (progress < duration) {
          requestAnimationFrame(step);
        }
      }

      requestAnimationFrame(step);
    }

    function toggleVisibility(selector, addClass, removeClass) {
      const elements = document.querySelectorAll(selector);
      elements.forEach(function (element) {
        element.classList.add(addClass);
        element.classList.remove(removeClass);
      });
    }
  }

  // Ensure the script runs when the page loads
  document.addEventListener("DOMContentLoaded", pricingInit);

  // Countdown Timer
  function countdownInit() {
    const countdowns = document.querySelectorAll("[data-countdown-target]");

    if (!countdowns.length) {
      return;
    }

    const pad = (value) => String(value).padStart(2, "0");

    const targets = Array.from(countdowns).map((element) => {
      const targetRaw = element.getAttribute("data-countdown-target");
      const targetDate = new Date(targetRaw);

      return {
        element,
        targetDate,
      };
    });

    const updateCountdown = ({ element, targetDate }) => {
      if (Number.isNaN(targetDate.getTime())) {
        return;
      }

      const now = new Date();
      let diff = targetDate.getTime() - now.getTime();
      const status = element.querySelector("[data-countdown-status]");

      if (diff <= 0) {
        diff = 0;
        element.classList.add("is-complete");
        if (status) {
          status.textContent = "Elkezdődött";
        }
      } else if (status) {
        status.textContent = "Az eseményig hátralévő idő";
      }

      const totalSeconds = Math.floor(diff / 1000);
      const days = Math.floor(totalSeconds / 86400);
      const hours = Math.floor((totalSeconds % 86400) / 3600);
      const minutes = Math.floor((totalSeconds % 3600) / 60);
      const seconds = totalSeconds % 60;

      const values = {
        days: String(days),
        hours: pad(hours),
        minutes: pad(minutes),
        seconds: pad(seconds),
      };

      Object.entries(values).forEach(([key, value]) => {
        const field = element.querySelector(
          `[data-countdown-value="${key}"]`,
        );
        if (field) {
          field.textContent = value;
        }
      });
    };

    const tick = () => {
      targets.forEach(updateCountdown);
    };

    tick();
    setInterval(tick, 1000);

    document.addEventListener("visibilitychange", () => {
      if (!document.hidden) {
        tick();
      }
    });
  }

  document.addEventListener("DOMContentLoaded", countdownInit);


  // ############################## nav sub-menu toggle ##############################
  const navDropdown = document.querySelector(".nav-dropdown");
  const navDropdownIcon = document.querySelector(".nav-dropdown-icon");

  if (navDropdown && navDropdownIcon) {
    navDropdown.addEventListener("click", () => {
      navDropdownIcon.classList.toggle("rotate-180");
    });
  }
})();
