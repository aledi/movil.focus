package com.android.focus;

import android.os.Bundle;
import android.support.design.widget.TabLayout;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentPagerAdapter;
import android.support.v4.view.ViewPager;
import android.support.v4.view.ViewPager.OnPageChangeListener;

import com.android.focus.R;
import com.android.focus.helpers.activities.ToolbarActivity;
import com.android.focus.paneles.fragments.PanelesFragment;
import com.android.focus.perfil.fragments.PerfilFragment;

import java.util.ArrayList;
import java.util.List;

public class MainActivity extends ToolbarActivity implements OnPageChangeListener {

    private Fragment fragment;
    private ViewPager viewPager;
    private ViewPagerAdapter adapter;

    // region Activity lifecycle
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        displayHomeAsUpEnabled = false;
        layoutId = R.layout.activity_main;
        title = getString(R.string.panels);
        super.onCreate(savedInstanceState);

        viewPager = (ViewPager) findViewById(R.id.view_pager);
        setUpViewPager();

        TabLayout tabLayout = (TabLayout) findViewById(R.id.tab_layout);

        if (tabLayout != null) {
            tabLayout.setupWithViewPager(viewPager);
        }
    }
    // endregion

    // region Helper methods
    private void setUpViewPager() {
        adapter = new ViewPagerAdapter(getSupportFragmentManager());
        adapter.addFragment(PanelesFragment.newInstance(), getString(R.string.panels));
        adapter.addFragment(PerfilFragment.newInstance(), getString(R.string.profile));
        viewPager.setAdapter(adapter);
        viewPager.addOnPageChangeListener(this);
    }
    // endregion

    // region Listeners
    @Override
    public void onPageScrollStateChanged(int state) {
        if (state == ViewPager.SCROLL_STATE_SETTLING) {
            setTitle(adapter.getPageTitle(viewPager.getCurrentItem()));
        }
    }

    @Override
    public void onPageScrolled(int position, float positionOffset, int positionOffsetPixels) {
        // Do nothing.
    }

    @Override
    public void onPageSelected(int position) {
        fragment = adapter.getItem(position);
    }
    // endregion

    // region OnBackPressed interface
    @Override
    public void onBackPressed() {
        if (fragment instanceof PerfilFragment) {
            ((PerfilFragment) fragment).handleOnBackPressedEvent();
        } else {
            super.onBackPressed();
        }
    }
    // endregion

    // region Static classes
    class ViewPagerAdapter extends FragmentPagerAdapter {

        private final List<Fragment> fragments = new ArrayList<>();
        private final List<String> titles = new ArrayList<>();

        ViewPagerAdapter(FragmentManager manager) {
            super(manager);
        }

        @Override
        public Fragment getItem(int position) {
            return fragments.get(position);
        }

        @Override
        public int getCount() {
            return fragments.size();
        }

        @Override
        public String getPageTitle(int position) {
            return titles.get(position);
        }

        void addFragment(Fragment fragment, String title) {
            fragments.add(fragment);
            titles.add(title);
        }
    }
    // endregion
}
