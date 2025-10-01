return {
    descriptions = {
        Back={},
        Blind={},
        Edition={},
        Enhanced={},
        Joker={
            j_kls_white = {
                name = "White",
                text = {
                    "Earn {C:money}$#1#{} if played hand",
                    "contains a {C:attention}Flush Five{}"
                }
            },
            j_kls_black = {
                name = "Black",
                text = {
                    "{C:clubs}Clubs{} and {C:hearts}Hearts{} count as the same suit,",
                    "{C:diamonds}Diamonds{} and {C:spades}Spades{} count as the same suit"
                }
            },
            j_kls_red = {
                name = "Red",
                text = {
                    "First discard {C:attention}destroys{} every discarded card"
                }
            },
            j_kls_blue = {
                name = "Blue",
                text = {
                    "Gains {C:chips}+#2#{} Chips",
                    "for each {C:attention}hand{} remaining",
                    "at end of round",
                    "{C:inactive}(Currently {C:chips}+#1#{C:inactive} Chips)"
                }
            },
            j_kls_yellow = {
                name = "Yellow",
                text = {
                    "Shuffles all Joker cards",
                    "at beginning of round,",
                    "earn {C:money}$#1#{} at end of round"
                }
            },
            j_kls_green = {
                name = "Green",
                text = {
                    "This Joker gains {C:chips}+#2#{} Chips",
                    "per reroll in the {C:attention}shop{},",
                    "amount {C:attention}resets{} after each {C:attention}Boss Blind{}",
                    "{C:inactive}(Currently {C:chips}+#1#{C:inactive} Chips)"
                }
            },
            j_kls_purple = {
                name = "Purple",
                text = {
                    "{X:mult,C:white}X#1#{} Mult",
                    "for each {C:attention}Lingo{} Joker"
                }
            },
            j_kls_brown = {
                name = "Brown",
                text = {
                    "{C:attention}-1{} Ante to win,",
                    "but shop prices are {C:attention}#1#%{} higher"
                }
            },
            j_kls_hui1 = {
                name = "Gray",
                text = {
                    "{C:attention}Stone Cards{} give an extra {C:chips}+#1#{} Chips and {C:mult}+#2#{} Mult",
                    "{X:mult,C:white}X#3#{} Mult per {C:attention}Stone Card{} if hand consists of {C:attention}5 Stone Cards{},",
                    "increases by {X:mult,C:white}X#4#{} for every level of {C:attention}High Card{}",
                    "{C:inactive}(Currently {}{X:mult,C:white}X#5#{}{C:inactive} Mult){}"
                }
            },
            j_kls_orange = {
                name = "Orange",
                text = {
                    "{C:attention}Face Cards{} and {C:attention}Aces{}",
                    "give {C:money}$#1#{} when scored"
                }
            },
            j_kls_magenta = {
                name = "Magenta",
                text = {
                    "{X:mult,C:white}X#1#{} Mult for all {C:attention}#2#s{} scored,",
                    "rank changes every round"
                }
            },
            j_kls_lime = {
                name = "Lime",
                text = {
                    "{X:mult,C:white}X#1#{} Mult for all {V:1}#2#{} scored,",
                    "rank changes every round"
                }
            },
            j_kls_mint = {
                name = "Mint",
                text = {
                    "{X:mult,C:white}X#2#{} Mult for every time",
                    "{C:attention}poker hand{} has been played this run"
                }
            },
            j_kls_lavender = {
                name = "Lavender",
                text = {
                    "Gives {C:money}${} at end of round equal to",
                    "the {C:attention}average sell value{} of the Jokers",
                    "to the {C:attention}left{} and {C:attention}right{} of this Joker,",
                    "rounded up to the nearest integer"
                }
            },
            j_kls_cream = {
                name = "Cream",
                text = {
                    "Each card gets {C:attention}bonus{} Chips when scored",
                    "equal to the {C:attention}average rank{} of all cards scored,",
                    "rounded up to the nearest integer",
                    "{C:inactive}(Jack = 11, Queen = 12, King = 13, Ace = 14){}"
                }
            },
            j_kls_cobalt = {
                name = "Cobalt",
                text = {
                    "A random Joker gains {C:money}$#1#{} {C:attention}sell value{}",
                    "at end of round"
                }
            },
            j_kls_cyan = {
                name = "Cyan",
                text = {
                    "Earn {C:money}$#1#{} if {C:attention}first time{} playing {C:attention}played hand{}"
                }
            },
            j_kls_tea_green = {
                name = "Tea Green",
                text = {
                    "This Joker gives {X:mult,C:white}X#1#{} Mult for",
                    "each Joker to the {C:attention}right{} of this one",
                    "{C:inactive}(Currently{} {X:mult,C:white}X#2#{} {C:inactive}Mult{})"
                }
            },
            j_kls_plum = {
                name = "Plum",
                text = {
                    "{X:mult,C:white}X#1#{} Mult if {C:attention}played hand{}",
                    "contains the following three ranks:",
                    "{C:attention}#2#, #3#, #4#{}, ranks change every round",
                    "{C:inactive}(One card can count for duplicate ranks){}"
                }
            },
            j_kls_brass = {
                name = "Brass",
                text = {
                    "This Joker gains {C:mult}+#2#{} Mult for",
                    "every {C:attention}round{} played this run",
                    "{C:inactive}(Currently {C:mult}+#3#{} Mult)"
                }
            },
            j_kls_fern = {
                name = "Fern",
                text = {
                    "{C:mult}+#1#{} Mult,",
                    "{C:green}#2# in #3#{} chance to create another {C:attention}Fern{}",
                    "{C:inactive}(Room not required){}"
                }
            },
            j_kls_icely = {
                name = "Restless Repetition",
                text = {
                    "Sold {C:attention}Lingo{} Jokers",
                    "give {X:mult,C:white}X#2#{} Mult",
                    "{C:inactive}(Currently {X:mult,C:white}X#1#{C:inactive} Mult){}",
                    "{C:inactive}chess battle advanced{}"
                }
            },
        },
        Other={},
        Planet={},
        Spectral={},
        Stake={},
        Tag={},
        Tarot={},
        Voucher={
            v_kls_welcomeback = {
                name = "Welcome Back",
                text = {
                    "{C:attention}-1{} Ante"
                }
            },
            v_kls_counterclockwise = {
                name = "Counterclockwise",
                text = {
                    "{C:attention}-1{} Ante,",
                    "{C:attention}-1{} Joker slot"
                }
            },
        },
    },
    misc = {
        achievement_descriptions={},
        achievement_names={},
        blind_states={},
        challenge_names={},
        collabs={},
        dictionary={
            k_kls_lingo_1 = "Lingo: Tier 1",
            k_kls_lingo_2 = "Lingo: Tier 2",
            k_kls_lingo_3 = "Lingo: Tier 3",
            k_kls_lingo_4 = "Lingo: Tier 4",
        },
        high_scores={},
        labels={},
        poker_hand_descriptions={},
        poker_hands={},
        quips={},
        ranks={},
        suits_plural={},
        suits_singular={},
        tutorial={},
        v_dictionary={},
        v_text={},
    },
}