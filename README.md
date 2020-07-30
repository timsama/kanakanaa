# KanaKanaa (カナかなあ) Japanese IME for Windower

### Welcome to KanaKanaa, a Japanese IME addon for Windower!

KanaKanaa allows you to type Japanese characters into FFXI using your EN-US keyboard, and provides autocomplete suggestions of common phrases as well as kanji replacements.

While this addon does not grant access to the IME embedded within FFXI itself--that functionality has been broken in Windower for some time--it adds its own, which although it may currently lag behind the official one, has the advantage of 1) being open-source, meaning that the community can update and tweak it to our hearts' content, and 2) it's a LUA add-on, which means that it won't get unexpectedly broken by a monthly version update.

### How to use
#### Installation
Copy the addon's contents into your Windower's /addons folder, under a /kanakanaa subfolder, or just use Windower's addon manager if this ends up getting approved by the Windower team.
#### Running KanaKanaa
To start manually, enter `lua load kanakanaa` in your Windower console, or to run automatically upon startup, add `<addon>kanakanaa</addon>` to your settings.xml's `<autoload>` section.

If the addon ran successfully, you will notice a small blue square next to your chat input bar. When the square contains **あ**, KanaKanaa is active, and will interpret the romaji you type as Hiragana or Katakana, while preventing those keypresses from reaching FFXI. When the square contains **A**, KanaKanaa is inactive, and will not interfere in the flow of your keypresses from keyboard to FFXI. You can switch between these modes by pressing Shift+Spacebar.

### Controls

#### Ctrl+Shift+K
This is a "panic sequence" that you can use to force reload KanaKanaa. You shouldn't generally expect to need it, but I added it because KanaKanaa *does* block some keyboard inputs from being passed to FFXI when active, and I don't want it to make you lose a battle in the event that it somehow gets into an error state. Note that KanaKanaa always starts in romaji mode, and force-reload is no exception.

#### Shift+Spacebar
This toggles whether or not KanaKanaa is active, and flushes the IME input text to FFXI's native chat bar/flushes the native chat bar text to the IME. In other words, you should always see the same text in your chat bar and IME bar, even when switching between them.

#### QWERTY Keys
As you type, romaji that have yet to indicate a kana character will be displayed in green. Once it becomes possible to do so, the green romaji will "snap" into kana displayed in blue, and an autocomplete menu of common phrases and Kanji with matching readings will appear above your typed kana.

#### ↑/↓ Keys
These are used to select autocomplete/autotranslate entries when the autocomplete/autotranslate menu is present. The currently-selected entry is displayed in green in the menu, and is duplicated in blue in the text entry bar.

#### Spacebar
Pressing spacebar when the autocomplete menu is present will accept the currently-selected autocomplete entry. Pressing spacebar when the autocomplete menu is not open will...do what it normally does and type a space.

#### Tab Key
These are used to open the autotranslate menu, as well as input the selected entry, if the menu is already open. The currently-selected entry is displayed in green in the menu, and your matching text is shown in green in the text entry bar

#### Enter Key
Pressing Enter when the autocomplete menu is **not** open will behave as it usually does and send a message consisting of the contents of the chat input. Pressing Enter when the autocomplete menu **is** open will accept the currently-selected autocomplete entry, type its characters into FFXI's chat input, then submit the message as it usually would.

#### Escape Key
Pressing Escape will exit out of the IME input bar, as well as clear FFXI's chat input--as it usually would. Although it exits the IME input bar, it doesn't disable KanaKanaa (use Shift+Spacebar for that).

#### Slash Key
Typing a slash allows you to type FFXI slash-commands as usual, and temporarily disables Kanakanaa functionality until you press Enter to send the command.

#### Shift Key
Holding Shift while you type allows you to enter full-width "Japanese style" capital letters.

### Commands

#### kkn set chatbarwidth
This sets the width of the chat bar, and saves the change in your config file. Setting chatbarwidth to nil or null restores the default width.

#### kkn set locale
This sets the locale to use for your keyboard. Currently-supported locales are en-US and es-ES, but I'm always happy to merge pull requests to add new locales.

#### kkn reset [chatbarwidth|locale|all]
Resets the specified setting to its default value.

### Final Thoughts
I've had a lot of fun working on this, and I hope that using it is just as enjoyable. 楽しんで下さい!