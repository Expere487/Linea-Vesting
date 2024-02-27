module linea_vesting::linear_vesting {
    // === Imports ===

    use sui::coin::{Self, Coin};
    use sui::object::{Self, UID};
    use sui::clock::{Self, Clock};
    use sui::tx_context::{Self, TxContext};
    use sui::balance::{Self, Balance};
    use sui::transfer;
    use sui::error::{Self, SuiError};

    // === Errors ===

    // Error code for invalid start date
    const EInvalidStartDate: u64 = 0;
    const EInvalidDuration: u64 = 1;

    // === Structs ===

    // Wallet struct
    struct Wallet {
        id: UID,
        // Balance of the wallet
        balance: Balance,
        // Start date of the claiming
        start: u64,
        // Total amount of Coin released
        released: u64,
        // Duration of the vesting
        duration: u64
    }

    // === Public-Mutative Functions ===

    /*
    * @notice Creates a new Wallet with the given token, start date, duration and context
    *
    * @param token: Coin<T> - The token to be vested
    * @param c: &Clock - The clock to get the current timestamp
    * @param start: u64 - The start date of the vesting
    * @param duration: u64 - The duration of the vesting
    * @param ctx: &mut TxContext - The transaction context
    *
    * @return Wallet<T> - The new Wallet
    */
    public fun new<T>(token: Coin<T>, c: &Clock, start: u64, duration: u64, ctx: &mut TxContext): Result<Wallet, SuiError> {
        ensure!(start >= clock::timestamp_ms(c), SuiError::new(EInvalidStartDate));
        ensure!(duration > 0, SuiError::new(EInvalidDuration));

        Ok(Wallet {
            id: object::new(ctx),
            balance: coin::into_balance(token),
            released: 0,
            start,
            duration,
        })
    }

    /*
    * @notice To claim the vested amount
    *
    * @param self: &mut Wallet<T> - The wallet to claim the vested amount
    * @param c: &Clock - The clock to get the current timestamp
    * @param ctx: &mut TxContext - The transaction context
    *
    * @return Coin<T> - The vested amount of Coin
    */
    public fun claim<T>(self: &mut Wallet, c: &Clock, ctx: &mut TxContext): Result<Coin<T>, SuiError> {
        let releasable = vesting_status(self, c)?;
        *&mut self.released += releasable;
        coin::from_balance(balance::split(&mut self.balance, releasable), ctx)
    }

    /*
    * @notice To destroy the wallet when wallet has zero balance
    *
    * @param self: Wallet - The wallet to destroy
    */
    public fun destroy_zero(self: Wallet) {
        let Wallet { id, start: _, duration: _, balance, released: _} = self;
        object::delete(id);
        balance::destroy_zero(balance);
    }

    // === Public-View Functions ===

    // Remaining functions remain the same...

    // === Private Functions ===

    // Remaining functions remain the same...
}
