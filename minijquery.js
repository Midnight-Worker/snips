const $ = selector => {
    const element = document.querySelector(selector);

    return {
        element,

        text(value) {
            element.textContent = value;
            return this;
        },

        html(value) {
            element.innerHTML = value;
            return this;
        },

        css(property, value) {
            element.style[property] = value;
            return this;
        },

        on(event, callback) {
            element.addEventListener(event, callback);
            return this;
        }
    };
};
