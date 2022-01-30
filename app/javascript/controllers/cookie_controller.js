import { Controller } from '@hotwired/stimulus';

/**
 *  Cookie setup
 *  {word_id: _ID of the WordLibrary word_, guesses: [{ guess }]
 * */

export default class extends Controller {
  initialize() {
    this.morelde_historyCookieName = 'moredle_history';
    this.moredle_historyExpiration = new Date(2147483647 * 1000).toUTCString();
    this.morelde_currentGuessCookieName = 'moredle_current';
    this.morelde_currentGuessCookieExpiration = this.getTimeToMidnight();
  }

  connect() {
    const currentGame = this.getCookie(this.morelde_currentGuessCookieName);
    setTimeout(() => {
      this.dispatch('getExistingGame', {
        detail: {
          guess: currentGame ? JSON.parse(currentGame) : null,
        },
      });
    }, 1000);
  }

  getTimeToMidnight() {
    const midnight = new Date();
    midnight.setHours(24);
    midnight.setMinutes(0);
    midnight.setSeconds(0);
    midnight.setMilliseconds(0);
    return midnight.toUTCString();
  }

  setCookie(name, expires, value, path = '/') {
    document.cookie =
      name +
      '=' +
      encodeURIComponent(value) +
      '; expires=' +
      expires +
      '; path=' +
      path;
  }

  getCookie(name) {
    return document.cookie.split('; ').reduce((r, v) => {
      const parts = v.split('=');
      return parts[0] === name ? decodeURIComponent(parts[1]) : r;
    }, '');
  }

  deleteCookie(name, path) {
    setCookie(name, '', -1, path);
  }

  updateCookies({ detail }) {
    let contentArray = [];
    const oldInfo = this.getCookie(this.morelde_currentGuessCookieName);
    if (oldInfo) {
      contentArray = JSON.parse(oldInfo);
    }
    contentArray.push(detail);
    this.setCookie(
      this.morelde_currentGuessCookieName,
      this.morelde_currentGuessCookieExpiration,
      JSON.stringify(contentArray)
    );
  }
}
