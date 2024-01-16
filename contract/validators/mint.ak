use aiken/dict
use aiken/hash.{Blake2b_224, Hash}
use aiken/interval.{Finite, Interval, IntervalBound, PositiveInfinity}
use aiken/list
use aiken/transaction.{Output, ScriptContext, Transaction, ValidityRange} as tx
use aiken/transaction/credential.{
  ScriptCredential, VerificationKey, VerificationKeyCredential,
}
use aiken/transaction/value

type Action {
  Basic
  Premium
  Burn
}

type POSIXTime =
  Int

validator {
  fn mint_product(redeemer: Action, context: ScriptContext) -> Bool {
    let ScriptContext { transaction, purpose } = context

    let Transaction { mint, outputs, validity_range, extra_signatories, .. } =
      transaction

    expect tx.Mint(policy_id) = purpose

    expect [(_, amount)] =
      mint
        |> value.from_minted_value()
        |> value.tokens(policy_id)
        |> dict.to_list()

    when redeemer is {
      Basic ->
        check_minting_conditions(
          outputs,
          extra_signatories,
          validity_range,
          120000000,
          amount,
        )
      Premium ->
        check_minting_conditions(
          outputs,
          extra_signatories,
          validity_range,
          130000000,
          amount,
        )
      Burn -> amount == -1
    }
  }
}

fn check_minting_conditions(
  outputs: List<Output>,
  signatories: List<Hash<Blake2b_224, VerificationKey>>,
  range: ValidityRange,
  nft_cost: Int,
  mint_amount: Int,
) -> Bool {
  let value_paid =
    outputs
      |> list.filter(
           fn(output) {
             when output.address.payment_credential is {
               VerificationKeyCredential(_) -> False
               ScriptCredential(hash) ->
                 hash == #""
             }
           },
         )
      |> list.foldr(0, fn(a, b) { value.lovelace_of(a.value) + b })
  let must_be_signed =
    list.has(
      signatories,
      #"",
    )
  // 1706572800000 is January 30th 2024 midnight GMT
  let before_deadline = must_mint_before_deadline(range, 1706572800000)
  before_deadline && value_paid == nft_cost && must_be_signed && mint_amount == 1
}

fn must_mint_before_deadline(range: ValidityRange, deadline: POSIXTime) {
  when range.upper_bound.bound_type is {
    Finite(tx_upper) -> tx_upper <= deadline
    _ -> False
  }
}

test mint_after_deadline_fails() {
  let range: ValidityRange =
    Interval {
      lower_bound: IntervalBound { bound_type: Finite(2), is_inclusive: True },
      upper_bound: IntervalBound { bound_type: Finite(5), is_inclusive: True },
    }

  !must_mint_before_deadline(range, 4)
}

test mint_at_deadline_succeeds() {
  let range: ValidityRange =
    Interval {
      lower_bound: IntervalBound { bound_type: Finite(2), is_inclusive: True },
      upper_bound: IntervalBound { bound_type: Finite(4), is_inclusive: True },
    }

  must_mint_before_deadline(range, 4)
}

test mint_before_deadline_succeeds() {
  let range: ValidityRange =
    Interval {
      lower_bound: IntervalBound { bound_type: Finite(2), is_inclusive: True },
      upper_bound: IntervalBound { bound_type: Finite(3), is_inclusive: True },
    }

  must_mint_before_deadline(range, 4)
}

test mint_with_infinite_upper_fails() {
  let range: ValidityRange =
    Interval {
      lower_bound: IntervalBound { bound_type: Finite(2), is_inclusive: True },
      upper_bound: IntervalBound {
        bound_type: PositiveInfinity,
        is_inclusive: True,
      },
    }

  !must_mint_before_deadline(range, 4)
}
