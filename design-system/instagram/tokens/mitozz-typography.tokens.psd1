@{
    system_name = 'Mitozz Editorial Sans'
    description = 'Shared typography sizing, spacing, tracking, and margin rules for Mitozz Instagram compositor assets.'
    safe_area = @{
        feed_margin_x = 60
        top_band_height = 96
        body_start_y = 148
        body_card_padding_x = 32
        body_card_padding_y = 30
        close_card_padding_x = 44
        close_card_padding_y = 34
        default_card_radius = 24
        wide_card_radius = 28
    }
    roles = @{
        cover_headline = @{
            font_family = 'Hiragino Sans'
            font_weight = 'W6'
            font_size = 58
            tracking = 0.24
            line_height = 67
        }
        feed_headline = @{
            font_family = 'Hiragino Sans'
            font_weight = 'W6'
            font_size = 52
            tracking = 0.14
            line_height = 62
        }
        cover_subline = @{
            font_family = 'Hiragino Sans'
            font_weight = 'W4'
            font_size = 28
            tracking = 0.02
            line_height = 40
        }
        feed_subline = @{
            font_family = 'Hiragino Sans'
            font_weight = 'W4'
            font_size = 28
            tracking = 0.02
            line_height = 39
        }
        panel_title = @{
            font_family = 'Hiragino Sans'
            font_weight = 'W6'
            font_size = 28
            tracking = 0.08
            line_height = 34
        }
        module_label = @{
            font_family = 'Hiragino Sans'
            font_weight = 'W6'
            font_size = 28
            tracking = 0.08
            line_height = 32
        }
        module_title = @{
            font_family = 'Hiragino Sans'
            font_weight = 'W6'
            font_size = 22
            tracking = 0.02
            line_height = 28
        }
        body = @{
            font_family = 'Hiragino Sans'
            font_weight = 'W4'
            font_size = 24
            tracking = 0.00
            line_height = 35
        }
        meta = @{
            font_family = 'Hiragino Sans'
            font_weight = 'W6'
            font_size = 18
            tracking = 0.04
            line_height = 22
        }
        close_title = @{
            font_family = 'Hiragino Sans'
            font_weight = 'W6'
            font_size = 30
            tracking = 0.08
            line_height = 38
        }
    }
    font_profiles = @{
        mitozz_sans = @{
            headline_families = @('Hiragino Sans', 'Yu Gothic UI', 'Yu Gothic', 'Meiryo')
            body_families = @('Hiragino Sans', 'Yu Gothic UI', 'Yu Gothic', 'Meiryo')
            accent_families = @('Hiragino Mincho ProN', 'Yu Mincho', 'MS PMincho', 'Times New Roman')
            css_headline_stack = '"Hiragino Sans", "Noto Sans JP", "Yu Gothic", "Hiragino Sans GB", "Meiryo", sans-serif'
            css_body_stack = '"Hiragino Sans", "Noto Sans JP", "Yu Gothic", "Hiragino Sans GB", "Meiryo", sans-serif'
            css_accent_stack = '"Hiragino Mincho ProN", "Times New Roman", serif'
            size_adjustments = @{
                cover_headline = 0
                feed_headline = 0
                close_title = 0
            }
        }
        humanist_sans = @{
            headline_families = @('Yu Gothic UI', 'Yu Gothic', 'Meiryo', 'Hiragino Sans')
            body_families = @('Yu Gothic UI', 'Yu Gothic', 'Meiryo', 'Hiragino Sans')
            accent_families = @('Hiragino Mincho ProN', 'Yu Mincho', 'MS PMincho', 'Times New Roman')
            css_headline_stack = '"Yu Gothic UI", "Yu Gothic", "Meiryo", "Hiragino Sans", "Noto Sans JP", sans-serif'
            css_body_stack = '"Yu Gothic UI", "Yu Gothic", "Meiryo", "Hiragino Sans", "Noto Sans JP", sans-serif'
            css_accent_stack = '"Hiragino Mincho ProN", "Times New Roman", serif'
            size_adjustments = @{
                cover_headline = 0
                feed_headline = 0
                close_title = 0
            }
        }
        editorial_serif = @{
            headline_families = @('Yu Mincho', 'Hiragino Mincho ProN', 'MS PMincho', 'Times New Roman')
            body_families = @('Hiragino Sans', 'Yu Gothic UI', 'Yu Gothic', 'Meiryo')
            accent_families = @('Yu Mincho', 'Hiragino Mincho ProN', 'MS PMincho', 'Times New Roman')
            css_headline_stack = '"Yu Mincho", "Hiragino Mincho ProN", "MS PMincho", "Times New Roman", serif'
            css_body_stack = '"Hiragino Sans", "Noto Sans JP", "Yu Gothic", "Meiryo", sans-serif'
            css_accent_stack = '"Hiragino Mincho ProN", "Times New Roman", serif'
            size_adjustments = @{
                cover_headline = 2
                feed_headline = 2
                close_title = 2
            }
        }
    }
    template_roles = @{
        global = @{
            eyebrow = @{
                font_family = 'headline'
                font_weight = '600'
                font_size = '46px'
                line_height = '1.18'
                letter_spacing = '0.06em'
            }
            headline = @{
                font_family = 'headline'
                font_weight = '600'
                font_size = '68px'
                line_height = '1.14'
                letter_spacing = '-0.035em'
            }
            headline_small = @{
                font_family = 'headline'
                font_weight = '600'
                font_size = '56px'
                line_height = '1.22'
                letter_spacing = '-0.024em'
            }
            subline = @{
                font_family = 'body'
                font_weight = '400'
                font_size = '32px'
                line_height = '1.5'
                letter_spacing = '0.01em'
            }
            panel_index = @{
                font_family = 'accent'
                font_weight = '600'
                font_size = '34px'
                line_height = '1'
                letter_spacing = '0'
            }
            panel_kicker = @{
                font_family = 'body'
                font_weight = '600'
                font_size = '20px'
                line_height = '1.2'
                letter_spacing = '0.12em'
            }
            panel_eyebrow = @{
                font_family = 'body'
                font_weight = '400'
                font_size = '26px'
                line_height = '1.36'
                letter_spacing = '0.01em'
            }
            meta_label = @{
                font_family = 'body'
                font_weight = '600'
                font_size = '22px'
                line_height = '1.2'
                letter_spacing = '0.16em'
            }
            meta_line = @{
                font_family = 'body'
                font_weight = '400'
                font_size = '28px'
                line_height = '1.45'
                letter_spacing = '0.01em'
            }
            meta_tag = @{
                font_family = 'body'
                font_weight = '500'
                font_size = '22px'
                line_height = '1'
                letter_spacing = '0.04em'
            }
        }
        portrait_cover = @{
            eyebrow = @{
                font_family = 'body'
                font_weight = '600'
                font_size = '34px'
                line_height = '1.3'
                letter_spacing = '0.1em'
            }
            headline = @{
                font_family = 'headline'
                font_weight = '600'
                font_size = '62px'
                line_height = '1.18'
                letter_spacing = '-0.028em'
            }
        }
        editorial = @{
            headline = @{
                font_family = 'headline'
                font_weight = '600'
                font_size = '60px'
                line_height = '1.18'
                letter_spacing = '-0.026em'
            }
            subline = @{
                font_family = 'body'
                font_weight = '400'
                font_size = '31px'
                line_height = '1.5'
                letter_spacing = '0.01em'
            }
        }
        editorial_close = @{
            headline = @{
                font_family = 'headline'
                font_weight = '600'
                font_size = '60px'
                line_height = '1.2'
                letter_spacing = '-0.026em'
            }
            subline = @{
                font_family = 'body'
                font_weight = '400'
                font_size = '30px'
                line_height = '1.52'
                letter_spacing = '0.01em'
            }
        }
        story = @{
            kicker = @{
                font_family = 'body'
                font_weight = '600'
                font_size = '32px'
                line_height = '1.2'
                letter_spacing = '0.14em'
            }
            headline = @{
                font_family = 'headline'
                font_weight = '600'
                font_size = '88px'
                line_height = '1.14'
                letter_spacing = '-0.03em'
            }
            body = @{
                font_family = 'body'
                font_weight = '400'
                font_size = '44px'
                line_height = '1.45'
                letter_spacing = '0.01em'
            }
            prompt = @{
                font_family = 'body'
                font_weight = '400'
                font_size = '40px'
                line_height = '1.35'
                letter_spacing = '0.01em'
            }
        }
        education = @{
            panel_index = @{
                font_family = 'accent'
                font_weight = '600'
                font_size = '34px'
                line_height = '1'
                letter_spacing = '0'
            }
            panel_kicker = @{
                font_family = 'body'
                font_weight = '600'
                font_size = '20px'
                line_height = '1.2'
                letter_spacing = '0.12em'
            }
            panel_eyebrow = @{
                font_family = 'body'
                font_weight = '400'
                font_size = '26px'
                line_height = '1.36'
                letter_spacing = '0.01em'
            }
            kicker = @{
                font_family = 'body'
                font_weight = '600'
                font_size = '24px'
                line_height = '1.2'
                letter_spacing = '0.14em'
            }
            headline = @{
                font_family = 'headline'
                font_weight = '700'
                font_size = '64px'
                line_height = '1.18'
                letter_spacing = '-0.03em'
            }
            body = @{
                font_family = 'body'
                font_weight = '500'
                font_size = '32px'
                line_height = '1.48'
                letter_spacing = '0.01em'
            }
            footer = @{
                font_family = 'body'
                font_weight = '500'
                font_size = '28px'
                line_height = '1.44'
                letter_spacing = '0.01em'
            }
            note = @{
                font_family = 'body'
                font_weight = '600'
                font_size = '24px'
                line_height = '1.35'
                letter_spacing = '0.12em'
            }
        }
        education_cover = @{
            headline = @{
                font_family = 'headline'
                font_weight = '700'
                font_size = '72px'
                line_height = '1.14'
                letter_spacing = '-0.034em'
            }
        }
        education_body = @{
            headline = @{
                font_family = 'headline'
                font_weight = '700'
                font_size = '60px'
                line_height = '1.2'
                letter_spacing = '-0.03em'
            }
        }
        education_close = @{
            headline = @{
                font_family = 'headline'
                font_weight = '700'
                font_size = '60px'
                line_height = '1.2'
                letter_spacing = '-0.03em'
            }
        }
    }
    review_rules = @(
        'Japanese copy should default to near solid setting; visible positive tracking is a display correction, not a baseline.',
        'Large Japanese headlines may use only slight optical tracking, and only after the line breaks are already correct.',
        'Headline line height should stay compact enough to feel editorial, while supporting copy should breathe more openly.',
        'Large multi-line Japanese headline blocks must be checked for block density; the headline and subline should not collapse into one dark mass.',
        'Display headlines should usually sit around a 1.08 to 1.18 line-height ratio, while body copy should sit around a 1.45 to 1.60 ratio.',
        'Protect the transition between the headline block and the first module; body cards should not crowd or overlap the reading rhythm of the title and subline.',
        'Card padding should remain consistent across the batch unless a slide role intentionally changes it.',
        'Closing-note cards should be centered as single compositional units, not treated like reused body cards.',
        'Image-backed covers need a protected text zone so the subject supports the headline instead of fighting it.',
        'Centered labels should be centered by actual text width, not by default origin placement.'
    )
}
