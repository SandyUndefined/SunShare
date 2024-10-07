module SunShare::SolarPanelRental {
    use std::vector;
    use aptos_framework::coin;
    use aptos_framework::aptos_coin::AptosCoin;
    use aptos_framework::signer;
    use aptos_framework::timestamp;

    // Structure for Solar Panel
    struct SolarPanel has key, store, drop, copy {
        owner: address,
        capacity: u64,
        rental_rate: u64,
        is_rented: bool
    }

    // Structure to handle rental agreements
    struct RentalAgreement has key, store, drop, copy {
        renter: address,
        panel_id: u64,
        rental_start: u64,
        energy_consumed: u64,
        amount_due: u64
    }

    // Registry to store all listed solar panels
    struct PanelRegistry has key {
        panels: vector<SolarPanel>
    }

    // Registry to store all active rental agreements
    struct RentalRegistry has key {
        agreements: vector<RentalAgreement>
    }

    /// Create a new listing (only for authenticated users)
    public fun list_panel(account: &signer, capacity: u64, rental_rate: u64) acquires PanelRegistry {
        let owner = signer::address_of(account); // Authenticated user's address
        let new_panel = SolarPanel { owner, capacity, rental_rate, is_rented: false };

        if (!exists<PanelRegistry>(owner)) {
            move_to(account, PanelRegistry { panels: vector::empty() });
        };

        let registry = borrow_global_mut<PanelRegistry>(owner);
        vector::push_back(&mut registry.panels, new_panel);
    }

    /// Get all available panels for a given owner
    public fun get_available_panels(owner: address): vector<SolarPanel> acquires PanelRegistry {
        assert!(exists<PanelRegistry>(owner), 1); // Ensure the owner has a registry
        let panels = &borrow_global<PanelRegistry>(owner).panels;
        let available_panels = vector::empty<SolarPanel>();
        let len = vector::length(panels);
        let i = 0;
        while (i < len) {
            let panel = vector::borrow(panels, i);
            if (!panel.is_rented) {
                vector::push_back(&mut available_panels, *panel);
            };
            i = i + 1;
        };
        available_panels
    }

    /// Rent a solar panel (only for logged-in users)
    public fun rent_panel(account: &signer, panel_id: u64) acquires PanelRegistry, RentalRegistry {
        let renter = signer::address_of(account);
        let panel_owner = get_panel_owner(panel_id);

        assert!(panel_owner != renter, 0);  // Cannot rent own panel

        let registry = borrow_global_mut<PanelRegistry>(panel_owner);
        let panel = vector::borrow_mut(&mut registry.panels, panel_id);

        assert!(!panel.is_rented, 1);  // Check if the panel is not rented

        let rental_start = timestamp::now_seconds();
        let new_agreement = RentalAgreement {
            renter,
            panel_id,
            rental_start,
            energy_consumed: 0,
            amount_due: 0
        };

        panel.is_rented = true;

        if (!exists<RentalRegistry>(renter)) {
            move_to(account, RentalRegistry { agreements: vector::empty() });
        };

        let rental_registry = borrow_global_mut<RentalRegistry>(renter);
        vector::push_back(&mut rental_registry.agreements, new_agreement);
    }

    /// Update the energy consumed by the user and calculate the amount due
    public fun update_energy_consumed(account: &signer, panel_id: u64, energy_used: u64) acquires RentalRegistry, PanelRegistry {
        let renter = signer::address_of(account);
        let panel_owner = get_panel_owner(panel_id);
        let registry = borrow_global_mut<RentalRegistry>(renter);

        let agreement = vector::borrow_mut(&mut registry.agreements, panel_id);

        agreement.energy_consumed = agreement.energy_consumed + energy_used;

        let panel_registry = borrow_global<PanelRegistry>(panel_owner);
        let panel = vector::borrow(&panel_registry.panels, panel_id);
        agreement.amount_due = agreement.energy_consumed * panel.rental_rate;
    }

    /// Complete the rental by transferring the due amount to the panel owner
    public fun complete_rental(account: &signer, panel_id: u64) acquires RentalRegistry, PanelRegistry {
        let renter = signer::address_of(account);
        let panel_owner = get_panel_owner(panel_id);

        let registry = borrow_global_mut<RentalRegistry>(renter);
        let agreement = vector::borrow_mut(&mut registry.agreements, panel_id);

        assert!(agreement.energy_consumed > 0, 1);  // Ensure that energy has been consumed

        let total_cost = agreement.amount_due;
        coin::transfer<AptosCoin>(account, panel_owner, total_cost);  // Transfer tokens

        // Mark the panel as no longer rented
        let panel_registry = borrow_global_mut<PanelRegistry>(panel_owner);
        let panel = vector::borrow_mut(&mut panel_registry.panels, panel_id);
        panel.is_rented = false;

        // Reset the rental agreement
        agreement.energy_consumed = 0;
        agreement.amount_due = 0;
    }

    /// Fetch the owner of the panel based on the panel ID
    public fun get_panel_owner(panel_id: u64): address acquires PanelRegistry {
        let possible_owners = vector::empty<address>();
        vector::push_back(&mut possible_owners, @0x1);  // Add known owners here

        let i = 0;
        let len = vector::length(&possible_owners);

        while (i < len) {
            let current_address = *vector::borrow(&possible_owners, i);
            if (exists<PanelRegistry>(current_address)) {
                let registry = borrow_global<PanelRegistry>(current_address);
                if (panel_id < vector::length(&registry.panels)) {
                    let panel = vector::borrow(&registry.panels, panel_id);
                    return panel.owner;
                }
            };
            i = i + 1;
        };

        abort 1  // Return a valid address if the panel is not found (use a valid known address)
    }

    /// View active rentals for a renter
    public fun get_active_rentals(renter: address): vector<RentalAgreement> acquires RentalRegistry {
        if (!exists<RentalRegistry>(renter)) {
            return vector::empty<RentalAgreement>();
        };

        let registry = &borrow_global<RentalRegistry>(renter).agreements;
        let active_rentals = vector::empty<RentalAgreement>();
        
        let len = vector::length(registry);
        let i = 0;
        while (i < len) {
            let agreement = vector::borrow(registry, i);
            // Push the RentalAgreement struct (without reference) into active_rentals
            vector::push_back(&mut active_rentals, *agreement);
            i = i + 1;
        };

        active_rentals
    }
}
