# Moredle / Aryadle

This is my version of Wordle, but with 6-letter words. It's mainly just for me to play around with Rails 7, Turbo and Stimulus. I am not trying to copy or infringe on any intellectual property of the original game... just for educational purposes :)

On the backend, there is a "Word Library" model that holds 365 words. Each of these words also has a serialized string of the number of iterations of each letter. Aka: "dazzle" = {d:1, a:1, z:2, l:1, e:1}

The Word Library model also handles the checking of attempts made to guess said word. This check method:

1. Makes sure that the word is in the "dictionary" (a text file of all 6 letter words I could find). If not, it sends back a "false" response which triggers the frontend to return an error to the user that their guess is incorrect.
2. Splits up the guess into each individual letter, and then loops through each letter against the actual sequence of letters in the actual word. It'll get:
   a) "success" if it's correct
   b) "warning" if it's correct but in the wrong place
   c) "danger" if it's incorrect
3. A secondary loop is had to make sure that responses to guesses against words with multiple same letters is not incorrectly responded to. For example, if the actual word is "dabble" and the user attempts the word "babble", the two b's in spots 3 and 4 are correct, but in the above logic, b in position 1 will still return a "warning." This check corrects for it.

The Word Library's admin panel uses Turbo for "single-page-app"-like dynamic changes when it comes to updating words.

---

On the frontend, there is a Stimulus based setup that, on inital load, starts the "game", "keyboard" and "cookie" controllers.

The game controller is where the bulk of the actions happens for the game logic, including collating the attempt and sending guesses to the backend to "check" them against the word. Note that the frontend never has access to the actual word of the day; as mentioned above, it's the backend's job to respond to each guess with clues for the next guess, in Wordle fashion.

The keyboard controller handles the keyboard, and passes interactions with the keyboard to the main games controller to handle each guess. The games controller's guess responses from the backend are also sent back into the keyboard controller to update the "danger", "warning" and "success" states of the keyboard.

The cookie controller's job is to cookie guesses made that day. This way, a user can return to the game till midnight local time and pick up where they left off.

---

Styling is kept to a minimum, really just Bootstrap 5, hence the reason for "success", "warning" and "danger" responses being returned ~ appending them as classes will render the correct background colour for the keyboard.
