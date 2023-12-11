import React from 'react';
import { Provider, useSelector } from 'react-redux';
import { AppActions, RootState, store } from './store';
import { ToastContainer } from 'react-toastify';
import { Box } from 'lr-components';
import { NextUIProvider } from '@nextui-org/react';
import AppActionHook from './components/AppActionHook';

function App() {
  const show = useSelector((state: RootState) => state.state.show);
  return (
    show && (
      <NextUIProvider>
        <Provider store={store}>
          <Box
            display='flex'
            position='absolute'
            flexWrap='wrap'
            justifyContent='center'
            alignItems='center'
            flexDirection='column'
            width={'50%'}
            height={'50%'}
            rGap={10}
          >
            {Object.keys(AppActions).map((action) => {
              return (
                <AppActionHook
                  action={action as keyof typeof AppActions}
                ></AppActionHook>
              );
            })}
          </Box>
          <Box
            width={'100%'}
            height={'100%'}
            display='flex'
            justifyContent='center'
            alignItems='center'
            className='prose'
            pointerEvents='none'
          ></Box>

          <ToastContainer pauseOnFocusLoss={false} hideProgressBar={true} />
        </Provider>
      </NextUIProvider>
    )
  );
}

export default App;
