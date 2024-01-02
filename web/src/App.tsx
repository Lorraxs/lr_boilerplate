import React, { createContext, useEffect, useState } from 'react';
import { useSelector } from 'react-redux';
import { AppActions, RootState } from './store';
import { ToastContainer } from 'react-toastify';
import { Box } from 'lr-components';
import { NextUIProvider } from '@nextui-org/react';
import AppActionHook from './components/AppActionHook';
import { isEnvBrowser } from './utils/misc';
import { fetchNui } from './utils/fetchNui';
import { DefaultUISetting, ISettingContext, UISetting } from './types';

const SettingContext = createContext<ISettingContext>(DefaultUISetting);

function App() {
  const show = useSelector((state: RootState) => state.main.show);
  const [setting, setSetting] = useState<UISetting>({ locale: {} });
  const L = (key: string) => setting.locale[key] || key;
  useEffect(() => {
    if (!isEnvBrowser()) {
      setTimeout(async () => {
        const UISetting = await fetchNui<UISetting>('AppReady');
        setSetting(UISetting);
      }, 2000);
    }
  }, [setSetting]);
  return (
    <SettingContext.Provider value={{ setting, setSetting, L }}>
      <NextUIProvider>
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
        {show && (
          <Box
            width={'100%'}
            height={'100%'}
            display='flex'
            justifyContent='center'
            alignItems='center'
            className='prose'
            pointerEvents='none'
          ></Box>
        )}
        <ToastContainer pauseOnFocusLoss={false} hideProgressBar={true} />
      </NextUIProvider>
    </SettingContext.Provider>
  );
}

export default App;
