import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  static targets = ['attempt', 'guesses', 'attemptsLeft', 'error'];
  static classes = ['loading', 'ready', 'complete'];

  initialize() {
    this.attemptsLeft = 6;
  }

  connect() {
    this.updateAttemptsLeft();
  }

  updateAttemptsLeft() {
    this.attemptsLeftTarget.innerHTML = this.attemptsLeft;
  }

  correctGuess(response, isDone) {
    this.guessesTarget.innerHTML += this.printGuess(response);
    this.attemptsLeft -= 1;
    this.updateAttemptsLeft();
    if (isDone || this.attemptsLeft == 0) {
      this.element.classList.add(this.completeClass);
    }
    this.errorTarget.classList.remove('d-block');
    this.errorTarget.classList.add('d-none');
    this.attemptTarget.value = '';
  }

  printGuess(guess) {
    let print = '<table class="table"><tr>';
    guess.forEach((element) => {
      print += `<td class="text-center border border-dark table-${element.check}">${element.letter}</td>`;
    });
    print += '</tr></table>';
    return print;
  }

  incorrectGuess() {
    this.errorTarget.classList.remove('d-none');
    this.errorTarget.classList.add('d-block');
  }

  guess() {
    fetch(`/guess?attempt=${this.attemptTarget.value}`)
      .then((response) => {
        return response.json();
      })
      .then(({ response, is_done }) => {
        if (response) {
          this.correctGuess(response, is_done);
          this.dispatch('guessMade', {
            detail: {
              guess: response,
              is_done: is_done,
            },
          });
        } else {
          this.incorrectGuess();
        }
      });
  }

  useExistingGame({ detail: { guess: currentGame } }) {
    if (currentGame) {
      currentGame.forEach(({ guess, is_done }) => {
        this.correctGuess(guess, is_done);
      });
    }
    this.element.classList.remove(this.loadingClass);
    this.element.classList.add(this.readyClass);
  }

  appendLetter({ detail: { content: letter } }) {
    if (this.attemptTarget.value.length < 6) {
      this.attemptTarget.value += letter;
    }
  }

  removeLetter() {
    this.attemptTarget.value = this.attemptTarget.value.slice(0, -1);
  }
}
