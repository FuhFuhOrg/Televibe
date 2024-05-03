package com.example.teletypesha.fragments;

import android.graphics.Typeface;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.Spinner;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.core.content.res.ResourcesCompat;
import androidx.fragment.app.Fragment;

import com.example.teletypesha.R;
import com.example.teletypesha.activitys.MainActivity;

public class SettingsFragment extends Fragment {
    boolean isFirstSelection = true;

    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.fragment_settings, container, false);

        SetFontsSpinner(view);

        return view;
    }

    private void SetFontsSpinner(View view){
        Spinner spinner = view.findViewById(R.id.set_font_spinner);
        ArrayAdapter<CharSequence> adapter = ArrayAdapter.createFromResource(getContext(),
                R.array.fonts_array, android.R.layout.simple_spinner_item);
        adapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
        spinner.setAdapter(adapter);

        spinner.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            @Override
            public void onItemSelected(AdapterView<?> parent, View view, int position, long id) {
                if (isFirstSelection) {
                    isFirstSelection = false;
                    return;
                }
                String selected = parent.getItemAtPosition(position).toString();
                Toast.makeText(requireActivity(), "Вы выбрали: " + selected, Toast.LENGTH_SHORT).show();

                Typeface typeface;
                switch (position){
                    case 0:
                        requireActivity().setTheme(R.style.comic_sans);
                        requireActivity().setContentView(R.layout.activity_main);
                        ((MainActivity)  requireActivity()).OpenSettingsFragment();
                        break;
                    case 1:
                        requireActivity().setTheme(R.style.inky_thin_pixels);
                        requireActivity().setContentView(R.layout.activity_main);
                        ((MainActivity)  requireActivity()).OpenSettingsFragment();
                        break;
                    case 2:
                        requireActivity().setTheme(R.style.swampy);
                        requireActivity().setContentView(R.layout.activity_main);
                        ((MainActivity)  requireActivity()).OpenSettingsFragment();
                        break;
                }
            }

            @Override
            public void onNothingSelected(AdapterView<?> parent) {
                // Действие при отсутствии выбора
            }
        });
    }
}
