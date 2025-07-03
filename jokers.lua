SMODS.Atlas{
    key = "Jokers",
    path = "Jokers.png",
    px = 71,
    py = 95
}
SMODS.Joker{
    key = "white",
    unlocked = true,
    loc_txt = {
        name = "White",
        text = {
            "{C:green}#1# in #2#{} chance to create a {C:dark_edition}Negative{} {C:tarot,T:c_death}Death{} card",
            "if played hand contains {C:attention}exactly 5{} cards with the same {C:attention}rank{} and {C:attention}suit{}"
        }
    },
    config = { extra = {odds = 5} },
    loc_vars = function(self, info_queue, card)
        return { vars = { (G.GAME and G.GAME.probabilities.normal or 1), card.ability.extra.odds} }
    end,
    rarity = 3,
    atlas = "Jokers",
    blueprint_compat = true,
    pos = {x = 0, y = 0},
    cost = 7,
    calculate = function(self, card, context)
        if context.before and next(context.poker_hands["Flush Five"]) and pseudorandom("white") < G.GAME.probabilities.normal / card.ability.extra.odds then
            G.E_MANAGER:add_event(Event({
                func = function()
                    local cardX = SMODS.add_card{key = "c_death"}
                    cardX:set_edition("e_negative", true)
                    cardX:add_to_deck()
                    card_eval_status_text(context.blueprint_card or card, "extra", nil, nil, nil, { message = "+ Death", colour = G.C.PURPLE})
                    G.consumeables:emplace(cardX)
                    return true
                end
            }))
        end
    end
}

SMODS.Joker{
    key = "black",
    unlocked = true,
    loc_txt = {
        name = "Black",
        text = {
            "{C:clubs}Clubs{} and {C:hearts}Hearts{} count as the same suit,",
            "{C:diamonds}Diamonds{} and {C:spades}Spades{} count as the same suit"
        }
    },
    rarity = 3,
    atlas = "Jokers",
    blueprint_compat = false,
    pos = {x = 1, y = 0},
    cost = 7,
}

function black_check(card, suit)
    if ((card.base.suit == "Spades" or card.base.suit == "Diamonds") and (suit == "Spades" or suit == "Diamonds")) then
        return true
    elseif (card.base.suit == "Hearts" or card.base.suit == "Clubs") and (suit == "Hearts" or suit == "Clubs") then
        return true
    end
    return false
end

local card_is_suit_ref = Card.is_suit
function Card:is_suit(suit, bypass_debuff, flush_calc)
    local ret = card_is_suit_ref(self, suit, bypass_debuff, flush_calc)
    if not ret and not SMODS.has_no_suit(self) and next(SMODS.find_card("j_kls_black")) then
        return black_check(self, suit)
    end
    return ret
end

SMODS.Joker{
    key = "red",
    unlocked = true,
    blueprint_compat = false,
    loc_txt = {
        name = "Red",
        text = {
            "First discard {C:attention}destroys{} every discarded card"
        }
    },
    config = { extra = {odds = 3} },
    loc_vars = function(self, info_queue, card)
        return { vars = { (G.GAME and G.GAME.probabilities.normal or 1), card.ability.extra.odds} }
    end,
    rarity = 3,
    atlas = "Jokers",
    pos = {x = 3, y = 0},
    cost = 7,
    calculate = function(self, card, context)
        if context.first_hand_drawn then
            local eval = function() return G.GAME.current_round.discards_used == 0 and not G.RESET_JIGGLES end
            juice_card_until(card, eval, true)
        end
        if context.discard and not context.blueprint and
            G.GAME.current_round.discards_used <= 0 then 
                return {
                    remove = true
                }
        end
    end
}

SMODS.Joker {
	key = "blue",
	loc_txt = {
		name = "Blue",
		text = {
			"Gains {C:chips}+#2#{} Chips",
			"for each {C:attention}hand{} remaining",
            "at end of round",
			"{C:inactive}(Currently {C:chips}+#1#{C:inactive} Chips)"
		}
	},
	config = { extra = { chips = 0, chip_gain = 7 } },
	rarity = 3,
	atlas = "Jokers",
    blueprint_compat = true,
	pos = { x = 2, y = 0 },
	cost = 7,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.chips, card.ability.extra.chip_gain } }
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			return {
				chip_mod = card.ability.extra.chips,
				message = localize { type = "variable", key = "a_chips", vars = { card.ability.extra.chips } }
			}
		end

		if context.end_of_round and not context.blueprint and context.main_eval then
			card.ability.extra.chips = card.ability.extra.chips + (card.ability.extra.chip_gain * G.GAME.current_round.hands_left)
			return {
				message = "Upgraded!",
				colour = G.C.CHIPS,
				card = card
			}
		end
	end
}

SMODS.Joker {
	key = "yellow",
	loc_txt = {
		name = "Yellow",
		text = {
			"Shuffles all Joker cards",
			"at beginning of round,",
            "earn {C:money}$#1#{} at end of round"
		}
	},
	config = { extra = { dollars = 6 } },
	rarity = 3,
	atlas = "Jokers",
    blueprint_compat = false,
	pos = { x = 1, y = 1 },
	cost = 7,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.dollars } }
	end,
    calculate = function(self, card, context)
		if context.setting_blind and not context.blueprint and #G.jokers.cards > 1 then
            G.E_MANAGER:add_event(Event({
                trigger = "after",
                delay = 0.2,
                func = function()
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            G.jokers:shuffle("yellow")
                            play_sound("cardSlide1", 0.85)
                            return true
                        end,
                    }))
                    delay(0.15)
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            G.jokers:shuffle("yellow")
                            play_sound("cardSlide1", 1.15)
                            return true
                        end
                    }))
                    delay(0.15)
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            G.jokers:shuffle("yellow")
                            play_sound("cardSlide1", 1)
                            return true
                        end
                    }))
                    delay(0.5)
                    return true
                end
            }))
		end
	end,
	calc_dollar_bonus = function(self, card)
        return card.ability.extra.dollars
    end
}

SMODS.Joker {
	key = "green",
	loc_txt = {
		name = "Green",
		text = {
			"This Joker gains {C:chips}+#2#{} Chips",
            "per reroll in the {C:attention}shop{},",
            "amount {C:attention}resets{} after each {C:attention}Boss Blind{}",
            "{C:inactive}(Currently {C:chips}+#1#{C:inactive} Chips)"
		}
	},
	config = { extra = { chips = 0, chip_gain = 30 } },
	rarity = 3,
	atlas = "Jokers",
    blueprint_compat = true,
	pos = { x = 3, y = 1 },
	cost = 7,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.chips, card.ability.extra.chip_gain } }
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			return {
				chip_mod = card.ability.extra.chips,
				message = localize { type = "variable", key = "a_chips", vars = { card.ability.extra.chips } }
			}
		end

		if context.reroll_shop and not context.blueprint and context.main_eval then
			card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chip_gain
			return {
				message = localize { type = "variable", key = "a_chips", vars = { card.ability.extra.chips } },
				colour = G.C.CHIPS,
				card = card
			}
		end

        if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
            if G.GAME.blind.boss and card.ability.extra.chips > 1 then
                card.ability.extra.chips = 0
                return {
                    message = "Reset",
                    colour = G.C.CHIPS
                }
            end
        end
	end
}

SMODS.Joker {
	key = "purple",
	loc_txt = {
		name = "Purple",
		text = {
			"This Joker gains {X:mult,C:white}X#2#{} Mult",
            "whenever a Joker is {C:attention}sold{},",
            "{C:inactive}(Currently {X:mult,C:white}X#1#{C:inactive} Mult)"
		}
	},
	config = { extra = { xmult = 1, xmult_gain = 0.1 } },
	rarity = 3,
	atlas = "Jokers",
    blueprint_compat = true,
	pos = { x = 4, y = 0 },
	cost = 7,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.xmult, card.ability.extra.xmult_gain } }
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			return {
				mult = card.ability.extra.xmult
			}
		end

		if context.selling_card and context.card.ability.set == "Joker" and context.card ~= card and not context.blueprint and context.main_eval then
			card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.xmult_gain
			return {
				message = localize { type = "variable", key = "a_xmult", vars = { card.ability.extra.xmult } },
				colour = G.C.MULT,
				card = card
			}
		end
	end
}

SMODS.Joker {
	key = "brown",
	loc_txt = {
		name = "Brown",
		text = {
			"{C:attention}-1{} Ante to win,",
            "but shop prices are {C:attention}#1#%{} higher"
		}
	},
	config = { extra = { percent = 40 } },
	rarity = 3,
	atlas = "Jokers",
    blueprint_compat = false,
	pos = { x = 4, y = 1 },
	cost = 7,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.percent } }
	end,
	add_to_deck = function(self, card, from_debuff)
        G.E_MANAGER:add_event(Event({
            func = function()
                G.GAME.discount_percent = G.GAME.discount_percent - card.ability.extra.percent
                G.GAME.win_ante = G.GAME.win_ante - 1
                for _, v in pairs(G.I.CARD) do
                    if v.set_cost then v:set_cost() end
                end
                return true
            end
        }))
    end,
    remove_from_deck = function(self, card, from_debuff)
        G.E_MANAGER:add_event(Event({
            func = function()
                G.GAME.discount_percent = G.GAME.discount_percent + card.ability.extra.percent
                G.GAME.win_ante = G.GAME.win_ante + 1
                for _, v in pairs(G.I.CARD) do
                    if v.set_cost then v:set_cost() end
                end
                return true
            end
        }))
    end
}

SMODS.Joker {
	key = "hui1", -- I can't decide which spelling of græy to use, so I just resorted to the Chinese word for it (灰)
	loc_txt = {
		name = "Grey", -- Will be changed when more localisation files are added
		text = {
            "{C:attention}Stone Cards{} give an extra {C:chips}+#1#{} Chips and {C:mult}+#2#{} Mult",
            "{X:mult,C:white}X#3#{} Mult per {C:attention}Stone Card{} if hand consists of {C:attention}5 Stone Cards{},",
            "increases by {X:mult,C:white}X#4#{} for every level of {C:attention}High Card{}",
            "{C:inactive}(Currently {}{X:mult,C:white}X#5#{}{C:inactive} Mult){}"
		}
	},
	config = { extra = { chips = 50, mult = 10, xmult = 1.07, xmult_gain = 0.03 } },
	rarity = 3,
	atlas = "Jokers",
    blueprint_compat = true,
	pos = { x = 2, y = 1 },
	cost = 7,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.chips, card.ability.extra.mult, card.ability.extra.xmult, card.ability.extra.xmult_gain, card.ability.extra.xmult + card.ability.extra.xmult_gain * G.GAME.hands["High Card"].level} }
	end,
	calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and SMODS.has_enhancement(context.other_card, "m_stone") then
            local stone_cards = 0
            for _, scored_card in ipairs(context.scoring_hand) do
                if SMODS.has_enhancement(scored_card, "m_stone") then
                    stone_cards = stone_cards + 1
                end
            end
            if stone_cards >= 5 then
                return {
                    chips = card.ability.extra.chips,
                    mult = card.ability.extra.mult,
                    xmult = card.ability.extra.xmult + card.ability.extra.xmult_gain * G.GAME.hands["High Card"].level,
                    card = context.other_card
                }
            else
                return {
                    chips = card.ability.extra.chips,
                    mult = card.ability.extra.mult,
                    card = context.other_card
                }
            end
        end
	end
}

SMODS.Joker {
	key = "orange",
	loc_txt = {
		name = "Orange",
		text = {
            "{C:attention}Face Cards{} and {C:attention}Aces{}",
            "give {C:money}$#1#{} when scored"
		}
	},
	config = { extra = { dollars = 1 } },
	rarity = 3,
	atlas = "Jokers",
    blueprint_compat = true,
	pos = { x = 0, y = 1 },
	cost = 7,
	loc_vars = function(self, info_queue, card)
		return { vars = {card.ability.extra.dollars} }
	end,
	calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and context.other_card:get_id() >= 10 then
            return {
                dollars = 1
            }
        end
    end
}

SMODS.Joker {
	key = "magenta",
	loc_txt = {
		name = "Magenta",
		text = {
            "{X:mult,C:white}X#1#{} Mult for all {C:attention}#2#s{} scored,",
            "rank changes every round"
		}
	},
	config = { extra = { xmult = 1.5 } },
	rarity = 3,
	atlas = "Jokers",
    blueprint_compat = true,
	pos = { x = 3, y = 2 },
	cost = 7,
	loc_vars = function(self, info_queue, card)
        local rank = (G.GAME.current_round.kls_mg_card or {}).rank or 'Ace'
		return { vars = { card.ability.extra.xmult, rank } }
	end,
	calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and
            context.other_card:get_id() == G.GAME.current_round.kls_mg_card.id then
            return {
                xmult = card.ability.extra.xmult
            }
        end
    end
}

local function reset_kls_magenta_rank()
    G.GAME.current_round.kls_mg_card = { rank = 'Ace' }
    local valid_mg_cards = {}
    for _, playing_card in ipairs(G.playing_cards) do
        if not SMODS.has_no_rank(playing_card) then
            valid_mg_cards[#valid_mg_cards + 1] = playing_card
        end
    end
    local mg_card = pseudorandom_element(valid_mg_cards, 'magenta' .. G.GAME.round_resets.ante)
    if mg_card then
        G.GAME.current_round.kls_mg_card.rank = mg_card.base.value
        G.GAME.current_round.kls_mg_card.id = mg_card.base.id
    end
end

SMODS.Joker {
	key = "lime",
	loc_txt = {
		name = "Lime",
		text = {
            "{X:mult,C:white}X#1#{} Mult for all {V:1}#2#{} scored,",
            "rank changes every round"
		}
	},
	config = { extra = { xmult = 1.2 } },
	rarity = 3,
	atlas = "Jokers",
    blueprint_compat = true,
	pos = { x = 2, y = 2 },
	cost = 7,
	loc_vars = function(self, info_queue, card)
        local suit = (G.GAME.current_round.kls_lm_card or {}).suit or 'Spades'
		return { vars = { card.ability.extra.xmult, suit, colours = { G.C.SUITS[suit] } } }
	end,
	calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and
            context.other_card:is_suit(G.GAME.current_round.kls_lm_card.suit) then
            return {
                xmult = card.ability.extra.xmult
            }
        end
    end
}

local function reset_kls_lime_suit()
    G.GAME.current_round.kls_lm_card = { suit = 'Spades' }
    local valid_lm_cards = {}
    for _, playing_card in ipairs(G.playing_cards) do
        if not SMODS.has_no_suit(playing_card) then
            valid_lm_cards[#valid_lm_cards + 1] = playing_card
        end
    end
    local lm_card = pseudorandom_element(valid_lm_cards, 'lime' .. G.GAME.round_resets.ante)
    if lm_card then
        G.GAME.current_round.kls_lm_card.suit = lm_card.base.suit
    end
end

SMODS.Joker {
	key = "mint",
	loc_txt = {
		name = "Mint",
		text = {
            "{X:mult,C:white}X#2#{} Mult for every time",
            "{C:attention}poker hand{} has been played this run"
		}
	},
	config = { extra = { xmult = 1, xmult_gain = 0.05 } },
	rarity = 3,
	atlas = "Jokers",
    blueprint_compat = true,
	pos = { x = 4, y = 2 },
	cost = 7,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.xmult, card.ability.extra.xmult_gain } }
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			return {
                xmult = card.ability.extra.xmult + card.ability.extra.xmult_gain * G.GAME.hands[context.scoring_name].played
			}
		end
	end
}

SMODS.Joker {
	key = "lavender",
	loc_txt = {
		name = "Lavender",
		text = {
            "Gives {C:money}${} at end of round equal to",
            "the {C:attention}average sell value{} of the Jokers",
            "to the {C:attention}left{} and {C:attention}right{} of this Joker,",
            "rounded up to the nearest integer"
		}
	},
	config = { extra = { dollars = 0 } },
	rarity = 3,
	atlas = "Jokers",
    blueprint_compat = true,
	pos = { x = 1, y = 2 },
	cost = 7,
	loc_vars = function(self, info_queue, card)
        local jleft, jright
        if card.area and card.area == G.jokers then
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i] == card then
                    jleft = G.jokers.cards[i - 1]
                    jright = G.jokers.cards[i + 1]
                end
            end
        end
        local left_cost = (jleft and jleft.sell_cost) or 0
        local right_cost = (jright and jright.sell_cost) or 0
        card.ability.extra.dollars = math.ceil((left_cost + right_cost) / 2)
		return { vars = { card.ability.extra.dollars } }
	end,
	calc_dollar_bonus = function(self, card)
        return card.ability.extra.dollars
    end
}

SMODS.Joker {
	key = "cream",
	loc_txt = {
		name = "Cream",
		text = {
            "Each card gets {C:attention}bonus{} Chips when scored",
            "equal to {C:attention}half the total rank{} of all cards scored,",
            "rounded up to the nearest integer",
            "{C:inactive}(Jack = 11, Queen = 12, King = 13, Ace = 14){}"
		}
	},
	config = { extra = {  } },
	rarity = 3,
	atlas = "Jokers",
    blueprint_compat = true,
	pos = { x = 0, y = 2 },
	cost = 7,
	loc_vars = function(self, info_queue, card)
		return { vars = { } }
	end,
	calculate = function(self, card, context)
        local totalid = 0
        if context.individual and context.cardarea == G.play then
            for _, scored_card in ipairs(context.scoring_hand) do
                if not SMODS.has_no_rank(scored_card) then
                    totalid = totalid + scored_card:get_id()
                end
            end
            context.other_card.ability.perma_bonus = (context.other_card.ability.perma_bonus or 0) + math.ceil(totalid / 2)
            return {
                message = "Upgrade!",
                colour = G.C.CHIPS
        }
        end
    end
}

function SMODS.current_mod.reset_game_globals(run_start)
    reset_kls_magenta_rank()
    reset_kls_lime_suit()
end