@{
    system_name = 'Steel Light'
    version = '2026-04-01'

    color_principles = @(
        'Keep Cloud White and Mist Blue as the permanent atmosphere base.'
        'Use Steel Blue for structure, labels, and dividers rather than heavy fills.'
        'Use Apricot only as a signal, not a dominant field color.'
        'Creative variation is allowed only inside the approved temperature range.'
        'A more engaging asset should still feel like it belongs beside the quieter ones.'
    )

    usage_guidance = @{
        cloud_white = '60%'
        mist_blue = '20%'
        steel_blue = '10%'
        apricot = '8%'
        mineral_navy = '2%'
    }

    base_roles = @{
        canvas_top = @{ hex = '#EEF4F7' }
        canvas_bottom = @{ hex = '#E5EDF2' }
        card = @{ hex = '#FCFCFB' }
        paper = @{ hex = '#F8F9F8' }
        header_wash = @{ hex = '#F0F5F8' }

        text_primary = @{ hex = '#31373D' }
        text_secondary = @{ hex = '#4E545A'; alpha = 214 }
        text_anchor = @{ hex = '#22323B' }

        atmosphere = @{ hex = '#DCE8EE' }
        atmosphere_soft = @{ hex = '#EEF2F4' }
        structure = @{ hex = '#6F8794' }
        structure_line = @{ hex = '#D6DFE5' }
        structure_line_faint = @{ hex = '#D6DFE5'; alpha = 120 }

        accent_signal = @{ hex = '#F48A5A' }
        accent_soft = @{ hex = '#E8B599' }
        accent_peach = @{ hex = '#F7E5DC' }
        neutral_warm = @{ hex = '#E9DDD3' }
    }

    palette_variants = @{
        default = @{
            description = 'The current production-balanced palette for education and Story support assets.'
            overrides = @{}
        }

        cool_focus = @{
            description = 'Slightly cooler and more clinical while staying inside the Steel Light world.'
            overrides = @{
                canvas_top = @{ hex = '#EDF4F8' }
                canvas_bottom = @{ hex = '#E3EDF3' }
                atmosphere = @{ hex = '#D8E7EE' }
                atmosphere_soft = @{ hex = '#ECF2F5' }
                structure = @{ hex = '#6C8695' }
                structure_line = @{ hex = '#D3DDE4' }
                accent_soft = @{ hex = '#E4B8A4' }
            }
        }

        warm_editorial = @{
            description = 'A slightly warmer editorial mode for more human, reassurance-led, or trust-led assets.'
            overrides = @{
                canvas_top = @{ hex = '#F2F4F5' }
                canvas_bottom = @{ hex = '#EBECEB' }
                atmosphere = @{ hex = '#DFE7EB' }
                atmosphere_soft = @{ hex = '#F1F2F1' }
                structure = @{ hex = '#738893' }
                structure_line = @{ hex = '#DCDDDD' }
                accent_soft = @{ hex = '#E9BEA8' }
                neutral_warm = @{ hex = '#E5D6C9' }
            }
        }
    }

    allowed_creative_play = @(
        'Shift between default, cool_focus, and warm_editorial only when the content angle benefits from it.'
        'Do not introduce new hue families outside the Steel Light range without updating the brand system.'
        'Keep text contrast stable even when atmosphere or accent warmth changes.'
        'When one batch uses a warmer or cooler variant, keep that batch internally consistent.'
    )
}
