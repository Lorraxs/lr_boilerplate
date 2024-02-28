// Will return whether the current environment is in a regular browser

import { toast } from 'react-toastify';
import { IResponse, IResponseSuccess } from '../types';

// and not CEF
// eslint-disable-next-line @typescript-eslint/no-explicit-any
export const isEnvBrowser = (): boolean => !(window as any).invokeNative;

// Basic no operation function
export const noop = () => {};

export const Sleep = (ms: number) => {
  return new Promise((resolve) => setTimeout(resolve, ms));
};

export const GuardResponse = (
  response: IResponse
): response is IResponseSuccess => {
  if (!response) return false;
  if (response.status === 'error') throw new Error(response.message);
  if (response.message) {
    toast.success(response.message);
  }
  return response.status === 'success';
};
