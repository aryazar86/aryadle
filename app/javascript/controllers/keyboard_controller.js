import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  static targets = ['keyboard'];

  initialize() {
    this.qwerty = [
      [
        { letter: 'q', status: 'light' },
        { letter: 'w', status: 'light' },
        { letter: 'e', status: 'light' },
        { letter: 'r', status: 'light' },
        { letter: 't', status: 'light' },
        { letter: 'y', status: 'light' },
        { letter: 'u', status: 'light' },
        { letter: 'i', status: 'light' },
        { letter: 'o', status: 'light' },
        { letter: 'p', status: 'light' },
      ],
      [
        { letter: 'a', status: 'light' },
        { letter: 's', status: 'light' },
        { letter: 'd', status: 'light' },
        { letter: 'f', status: 'light' },
        { letter: 'g', status: 'light' },
        { letter: 'h', status: 'light' },
        { letter: 'j', status: 'light' },
        { letter: 'k', status: 'light' },
        { letter: 'l', status: 'light' },
      ],
      [
        { letter: 'z', status: 'light' },
        { letter: 'x', status: 'light' },
        { letter: 'c', status: 'light' },
        { letter: 'v', status: 'light' },
        { letter: 'b', status: 'light' },
        { letter: 'n', status: 'light' },
        { letter: 'm', status: 'light' },
      ],
    ];
    console.log('keyboard initialized');
  }

  connect() {
    this.drawKeyboard();
  }

  drawKeyboard() {
    let printedKeyboard = '';
    this.qwerty.forEach((row, index) => {
      printedKeyboard += '<div class="mb-2">';
      if (index == this.qwerty.length - 1) {
        printedKeyboard += `<span
            data-action="click->keyboard#enterClicked"
            class="d-inline-block p-2 p-sm-3 mx-1 bg-light bg-opacity-50"
          >
            Enter
          </span>`;
      }
      row.forEach((key) => {
        printedKeyboard += `<span data-action="click->keyboard#keyClicked" data-keyboard-letter-param="${key.letter}" class="d-inline-block p-2 p-sm-3 mx-1 bg-${key.status} bg-opacity-50">${key.letter}</span>`;
      });
      if (index == this.qwerty.length - 1) {
        printedKeyboard += `<span
            data-action="click->keyboard#deleteClicked"
            class="d-inline-block p-2 p-sm-3 mx-1 bg-light bg-opacity-50"
          >
            Backspace
          </span>`;
      }
      printedKeyboard += '</div>';
    });
    this.keyboardTarget.innerHTML = printedKeyboard;
  }

  keyClicked(event) {
    this.dispatch('keyStruck', { detail: { content: event.params.letter } });
  }

  enterClicked() {
    this.dispatch('enterStruck');
  }

  deleteClicked() {
    this.dispatch('deleteStruck');
  }

  qwertyCheck(piece) {
    this.qwerty.forEach((row) =>
      row.forEach((key) => {
        if (
          key.letter == piece.letter &&
          (key.status != 'success' ||
            (key.status == 'warning' && piece.check == 'danger'))
        ) {
          key.status = piece.check;
        } else {
          null;
        }
      })
    );
  }

  updateKeyboard({ detail: { guess: guess } }) {
    guess.forEach((piece) => {
      if (piece.guess) {
        piece.guess.forEach((secondaryPiece) =>
          this.qwertyCheck(secondaryPiece)
        );
      } else {
        this.qwertyCheck(piece);
      }
    });

    this.drawKeyboard();
  }
}
