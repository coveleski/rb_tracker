customcardkey = ScriptHost:CreateLuaItem()
customcardkey.Name = "Card Key"
customcardkey.ItemState = {}
customcardkey.ItemState['option'] = 'vanilla'
customcardkey.ItemState['qty'] = 0
customcardkey.ItemState['active'] = false
customcardkey.Icon = ImageReference:FromPackRelativePath('images/items/cardkey.png')
customcardkey.IconMods = "@disabled"

function customcardkey:CanProvideCodeFunc(code)
    return code == 'custom_cardkey'
end

function customcardkey:ProvidesCodeFunc(code)

    --if it's active and vanilla cardkey, provide appropriate codes
    if self.ItemState['active'] then
        local option = self.ItemState['option']
        if option == 'vanilla' then
            if code == 'cardkey' or code == 'keyitem' then
                return 1
            end
        --same thing here but  for progressive cardkey
        elseif option == 'progressive' then
            if code == 'cardkey_progressive' or code == 'keyitem' then
                return self.ItemState['qty']
            end
        end
    end
    return 0
end
function customcardkey:OnLeftClickFunc()
    local mode = self.ItemState['option']
    --return early if we have split cardkeys
    if mode == 'split' then
        return
    end
    -- if we're in progressive mode, increment quantity
    if mode == 'progressive' and self.ItemState['qty'] < 10 then
        set_qty(self, self.ItemState['qty'] + 1)
    end
    --set as active
    if not self.ItemState['active'] then
        self.ItemState['active'] = true
        self.IconMods = ''
    end
end

function customcardkey:OnRightClickFunc()

    local mode = self.ItemState['option']
    --return early if it's split
    if mode == 'split' then
        return
    end
        
    -- if it's in the progressive state, want to update the quantity
    if mode == 'progressive' and self.ItemState['qty'] > 0 then
        set_qty(self, self.ItemState['qty'] -1 )
    end
    --if it's vanilla, we set it to disabled (if it's not already)
    if mode == 'vanilla' and self.ItemState['active'] then
        self.ItemState['active'] = false
        self.IconMods = "@disabled"
    end
end

function customcardkey:OnMiddleClickFunc()

    local stage = Tracker:FindObjectForCode('opt_cardkey').CurrentStage
    if stage  == 0 then
        self.ItemState['option'] = 'vanilla'
        self.Icon = ImageReference:FromPackRelativePath('images/items/cardkey.png')
        self.Name = "Card Key"
        if not self.ItemState['active'] then
            self.IconMods = '@disabled'
        end
    elseif stage  == 1 then
        self.ItemState['option'] = 'progressive'
        self.Icon = ImageReference:FromPackRelativePath('images/items/cardkeyprog.png')
        self.Name = "Progressive Card Key"
        set_qty(self, self.ItemState['qty'])
        
    else
        self.ItemState['option'] = 'split'
        self.Icon = ImageReference:FromPackRelativePath('images/items/arrow_green.png')
        self.Name = "For Split Card Key, look below"
        self.IconMods = ''
    end
end

--updates item quanitity state and updates the overlay to display current quantity
function set_qty(self, qty)
    self.ItemState['qty'] = qty
    if qty ~= 0 then
        set_active(self, true)
        self.IconMods = "overlay|images/overlays/" .. qty + 1 .. '.png'
    end
    if qty == 0 then
        self:SetOverlay('')
        set_active(self, false)
    end
end
--sets item active state and update the img to match
function set_active(self, active)
    self.ItemState['active'] = active
    if active then
        self.IconMods = ''
    else
        self.IconMods = '@disabled'
    end
end

function reset_cardkey(self)
    self.Name = "Card Key"
    self.ItemState['option'] = 'vanilla'
    self.ItemState['qty'] = 0
    self.ItemState['active'] = false
    self.Icon = ImageReference:FromPackRelativePath('images/items/cardkey.png')
    self.IconMods = "@disabled"
end