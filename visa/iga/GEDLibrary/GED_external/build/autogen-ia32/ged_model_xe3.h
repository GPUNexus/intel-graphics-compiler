/*========================== begin_copyright_notice ============================

Copyright (C) 2017-2021 Intel Corporation

SPDX-License-Identifier: MIT

============================= end_copyright_notice ===========================*/

/*
 * !!! DO NOT EDIT THIS FILE !!!
 *
 * This file was automagically crafted by GED's model parser.
 */


#ifndef GED_MODEL_XE3__H
#define GED_MODEL_XE3__H

#include "common/ged_ins_decoding_table.h"
#include "common/ged_compact_mapping_table.h"

namespace GED_MODEL_NS_XE3
{

/*!
 * This table maps every possible opcode value (even for non-existing opcodes) to its respective top level decoding, encoding
 * restrictions and mapping tables (where applicable). Tables that are not supported in this model (either no compaction, or opcodes
 * which are not supported at all) are mapped to NULL pointers.
 */
extern OpcodeTables Opcodes[128];
} // namespace GED_MODEL_NS_XE3
#endif // GED_MODEL_XE3__H
