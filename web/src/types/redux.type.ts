import { Dispatch } from '@reduxjs/toolkit';
import { RootState } from '../store';

export type AsyncThunkConfig = {
  state: RootState;
  dispatch: Dispatch;
  /** type of the `extra` argument for the thunk middleware, which will be passed in as `thunkApi.extra` */
  extra?: unknown;
  /** type to be passed into `rejectWithValue`'s first argument that will end up on `rejectedAction.payload` */
  rejectValue?: unknown;
  /** return type of the `serializeError` option callback */
  serializedErrorType?: unknown;
  /** type to be returned from the `getPendingMeta` option callback & merged into `pendingAction.meta` */
  pendingMeta?: unknown;
  /** type to be passed into the second argument of `fulfillWithValue` to finally be merged into `fulfilledAction.meta` */
  fulfilledMeta?: unknown;
  /** type to be passed into the second argument of `rejectWithValue` to finally be merged into `rejectedAction.meta` */
  rejectedMeta?: unknown;
};

export type IResponseSuccess<T = unknown> = {
  status: 'success';
  data: T;
  message?: string;
};

export type IResponseError = {
  status: 'error';
  message: string;
};

export type IResponse<T = unknown> = IResponseSuccess<T> | IResponseError;
