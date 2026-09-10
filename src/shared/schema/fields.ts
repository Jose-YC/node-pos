import { z } from 'zod';

export const stringField = () =>
  z.string({
    error: (issue) => {
      if (issue.input === undefined || issue.input === null) return 'is required';
      return 'must be a string';
    },
  }).trim().min(1, 'cannot be empty');

export const numberField = () =>
  z.number({
    error: (issue) => {
      if (issue.input === undefined || issue.input === null) return 'is required';
      return 'must be a number';
    },
  }).int();

export const arrayNumberField = () =>
  z.array(
    numberField(),
    {
      error: (issue) => {
        if (issue.input === undefined || issue.input === null) return 'is required';
        return 'must be an array';
      },
    }
  ).refine(
    (items) => new Set(items).size === items.length,
    'must not contain duplicates'
  );