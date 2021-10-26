---
title: "Skyrim Randomiser"
date: 2021-10-26T13:07:22+01:00
draft: true
comments: false
images:
---

{{< rawhtml >}}

 <style>
        * {
            box-sizing: border-box;
        }
        /* Create three equal columns that floats next to each other */
        

        .column {
            float: left;
            width: 50%;
            padding: 10px;
            height: 300px;
            /* Should be removed. Only for demonstration */
        }
        /* Clear floats after the columns */
        
        .row:after {
            content: "";
            display: table;
            clear: both;
        }
    </style>

    <script>
        const mqs = ["College of Winterhold", "Companions", "Dark Brotherhood", "Imperial Legion OR Stormcloaks", "Thieves Guild", "Dawnguard OR Volkihar Vampire Clan"];
        const magick = ["Alteration", "Conjuration", "Destruction", "Enchanting", "Illusion", "Restoration"];
        const cmbt = ["Archery", "Block", "Heavy Armor", "One - handed", "Smithing", "Two - handed"];
        const sthl = [
            "Alchemy", "Light Armor", "Lockpicking", "Pickpocket", "Sneak", "Speech"
        ];
        const skills = magick.concat(cmbt, sthl);
        const races = ["Argonian", "Breton", "Dark Elf", "High Elf", "Imperial", "Khajiit", "Nord", "Orc", "Redguard", "Wood Elf"];

        const challenges = ["Cannot comprehend money, this character cannot hold more than 100 Gold",
            "Elf-phobia, cannot use any Elven Weapons or Armour", "Afraid of Horses, cannot use carriages or ride horses",
            "Blunt Obsessed, cannot use sharp weapons (swords)", "Hates the cold (cannot wait outdoors)", "Hobbit feet (cannot wear shoes/boots)", "Sensitive stomach (cannot eat uncooked food", "Hates the Empire (must avoid when possible and join Stormcloaks)", "Sticky fingers (if you see something you want, you need to have it)"
        ];



        function makeDropD(arr, eleI, skip) {
            var select = document.getElementById(eleI);
            var options = mqs;
            for (var i = 1; i < options.length; i++) {
                // if (i == skip) {
                //     continue;
                // }
                var opt = i;
                var el = document.createElement("option");
                el.textContent = opt;
                el.value = opt;
                select.appendChild(el);
            }
        }

        function randSelect(arr, n) {

            const shuffled = arr.sort(() => 0.5 - Math.random());
            let selected = shuffled.slice(0, n);
            return selected
        }

        function arrToList(arr) {
            return '<li>' + arr.join('</li><li>') + '</li>'
        }

        function generate() {

            document.getElementById("quests").innerHTML = arrToList(randSelect(mqs, parseInt(document.getElementById("mqsDr").value)));
            document.getElementById("skills").innerHTML = arrToList(randSelect(skills, parseInt(document.getElementById("skillsDr").value)));
            document.getElementById("misc").innerHTML = arrToList(randSelect(challenges, parseInt(document.getElementById("challengeDr").value)))
            document.getElementById("character").innerHTML = arrToList(randSelect(races, 1));
        }
    </script>


<form id="frm1">
        <label for="mqsDr">Number of Main Quests to complete:</label>
        <select name="mqsDr" id="mqsDr">
            <option value="1">1</option>
        </select>
        <br>
        <label for="skillsDr">Number of Skills to main:</label>
        <select name="skillsDr" id="skillsDr">
            <option value="6">6</option>
        </select>
        <br>
        <label for="challengeDr">Number of Challenges to Attempt:</label>
        <select name="challengeDr" id="challengeDr">
            <option value="0">0</option>
        </select>
    </form>

    <script>
        makeDropD(mqs, "mqsDr", 1);
        makeDropD(skills, "skillsDr", 6);
        makeDropD(challenges, "challengeDr", 0);
    </script>

    <p>Click "Generate" to get a randomized challenge for Skyrim.</p>

    <button onclick="generate()" , style="color: black;">Generate</button>
    <button onClick="window.location.reload();" , style="color: black;">Reset</button>

    <p id="demo"></p>


    <h2>Your Quest(s) and Character:</h2>

    <div class="row">
        <div class="column" style="background-color:#aaa;">
            <h2>Main Quests to complete</h2>
            <p id="quests"></p>
        </div>

        <div class="column" style="background-color:#bbb;">
            <h2>Skills</h2>
            <p id="skills"></p>
        </div>
        <div class="column" style="background-color:#aaa;">
            <h2>Character Race</h2>
            <p id="character"></p>
        </div>
        <div class="column" style="background-color:#bbb;">
            <h2>Misc Challenges</h2>
            <p id="misc"></p>
        </div>
    </div>
{{< /rawhtml >}}