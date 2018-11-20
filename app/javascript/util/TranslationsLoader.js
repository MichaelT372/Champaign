// @flow
// champaign-i18n is an external (aliases to window.I18n)
// see config/webpack/custom.js to see where it's aliased
import flatten from 'flat';
import { mapValues, pick } from 'lodash';
import type { I18nFlatDict } from 'champaign-i18n';
import I18n from 'champaign-i18n';
import { replaceInterpolations } from './locales/helpers';
import IntlMessageFormat from 'intl-messageformat';

if (!window.I18n.flat) {
  window.I18n.flat = mapValues(I18n.translations, tree =>
    mapValues(flatten(tree), replaceInterpolations)
  );
}

const translations = window.I18n.flat;

export default function loadTranslations(locale: string) {
  if (!translations[locale]) {
    throw new Error(`Unsuported locale: ${locale}`);
  }
  return translations[locale];
}
