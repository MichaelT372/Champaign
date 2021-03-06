// @flow

import type { FormField } from '../reducers';

export type DonationBands = { [id: string]: number[] };

export type EnumRecurringDefault = 'one_off' | 'recurring' | 'only_recurring';

export type FeaturedAmounts = { [id: string]: number };

export type FeaturedAmountState = {
  donationFeaturedAmount?: number,
  preselectAmount: boolean,
};

export type ActionFormField = { [key: string]: string };

export type Fundraiser = {
  currency: string,
  currentPaymentType: PaymentType,
  currentStep: number,
  disableSavedPayments: boolean,
  directDebitOnly: boolean,
  donationAmount?: number,
  donationBands: DonationBands,
  donationFeaturedAmount?: number,
  fields: FormField[],
  form: Object,
  formId: string,
  formValues: Object,
  freestanding?: boolean,
  oneClickError?: boolean,
  oneClick: boolean,
  outstandingFields: string[],
  paymentMethods: any[],
  paymentTypes: PaymentType[],
  preselectAmount: boolean,
  recurring: boolean,
  recurringDefault: EnumRecurringDefault,
  showDirectDebit: boolean,
  storeInVault: boolean,
  submitting: boolean,
  title: string,
};

export type FundraiserAction =
  | { type: 'initialize_fundraiser', payload: FundraiserInitializationOptions }
  | { type: '@@chmp:action_form:updated', payload: ActionFormField }
  | { type: 'change_amount', payload: ?number }
  | { type: 'change_currency', payload: string }
  | { type: 'change_step', payload: number }
  | { type: 'one_click_failed' }
  | { type: 'preselect_amount', payload: boolean }
  | { type: 'reset_member' }
  | { type: 'set_direct_debit_only', payload: boolean }
  | { type: 'set_donation_bands', payload: DonationBands }
  | { type: 'set_payment_type', payload: PaymentType }
  | { type: 'set_recurring', payload: boolean }
  | { type: 'set_recurring_defaults', payload?: string }
  | { type: 'set_submitting', payload: boolean }
  | { type: 'set_store_in_vault', payload: boolean }
  | { type: 'search_string_overrides', payload: { [key: string]: string } }
  | { type: 'update_form', payload: { [key: string]: any } };

export type FundraiserInitializationOptions = {
  amount: string,
  currency: string,
  donationBands: DonationBands,
  fields: FormField[],
  formValues: { [key: string]: string },
  formId: string,
  freestanding: boolean,
  oneClick?: boolean,
  oneClickError: boolean,
  outstandingFields: string[],
  pageId: string,
  preselectAmount: boolean,
  recurringDefault: EnumRecurringDefault,
  title: string,
};

export type PaymentType = 'card' | 'paypal' | 'gocardless' | 'google' | 'apple';

export type RecurringState = {
  recurring: boolean,
  recurringDefault: EnumRecurringDefault,
};
